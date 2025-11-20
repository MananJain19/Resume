<?php include 'connect.php';
if($_SERVER['REQUEST_METHOD']!=='POST'){ header('Location:index.php'); exit; }
$qtys = $_POST['qty'] ?? []; $customer = trim($_POST['customer_name'] ?? 'Walk-in'); $email = trim($_POST['email'] ?? ''); $use_points = isset($_POST['use_points']);
$items = []; foreach($qtys as $id=>$q){ $q=(int)$q; if($q>0) $items[(int)$id]=$q; }
if(!$items){ echo '<p>No items selected. <a href="index.php">Back</a></p>'; exit; }
// ensure customer record exists (simple: by email if provided else by name)
$customer_id = null;
if($email){
  $stmt = $pdo->prepare('SELECT * FROM customers WHERE email=? LIMIT 1'); $stmt->execute([$email]); $c=$stmt->fetch();
  if($c) $customer_id=$c['id']; else { $stmt=$pdo->prepare('INSERT INTO customers (name,email,total_points) VALUES (?,?,0)'); $stmt->execute([$customer,$email]); $customer_id=$pdo->lastInsertId(); }
} else {
  // try find by name
  $stmt = $pdo->prepare('SELECT * FROM customers WHERE name=? LIMIT 1'); $stmt->execute([$customer]); $c=$stmt->fetch();
  if($c) $customer_id=$c['id']; else { $stmt=$pdo->prepare('INSERT INTO customers (name,email,total_points) VALUES (?,?,0)'); $stmt->execute([$customer,$email]); $customer_id=$pdo->lastInsertId(); }
}
// compute total
$in = implode(',', array_fill(0,count($items),'?'));
$stmt = $pdo->prepare("SELECT id,price FROM menu_items WHERE id IN ($in)"); $stmt->execute(array_keys($items)); $rows=$stmt->fetchAll();
$prices=[]; foreach($rows as $r) $prices[$r['id']]=$r['price'];
$total=0; foreach($items as $id=>$q) $total += $prices[$id]*$q;
// apply points if requested
$discount = 0;
if($use_points && $customer_id){
  $stmt = $pdo->prepare('SELECT total_points FROM customers WHERE id=?'); $stmt->execute([$customer_id]); $c=$stmt->fetch();
  $points = (int)$c['total_points'];
  if($points>0){
    // use up to total (1 point = ₹1), but not more than total
    $discount = min($points, $total);
    $total -= $discount;
    // deduct points
    $stmt = $pdo->prepare('UPDATE customers SET total_points=total_points-? WHERE id=?'); $stmt->execute([$discount,$customer_id]);
  }
}
// insert order
$pdo->beginTransaction();
try{
  $stmt = $pdo->prepare('INSERT INTO orders (customer_name,total,status,created_at,delivery_boy_id) VALUES (?,?,?,?,NULL)');
  $stmt->execute([$customer,$total,'pending',date('Y-m-d H:i:s')]);
  $order_id = $pdo->lastInsertId();
  $stmt = $pdo->prepare('INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (?,?,?,?)');
  foreach($items as $id=>$q){ $stmt->execute([$order_id,$id,$q,$prices[$id]]); }
  // reward points: 10% of original total (before discount) round down
  $earned = floor((array_sum(array_map(function($id,$q) use($prices){return $prices[$id]*$q;}, array_keys($items), $items)) * 0.10));
  if($customer_id && $earned>0){ $stmt=$pdo->prepare('UPDATE customers SET total_points=total_points+? WHERE id=?'); $stmt->execute([$earned,$customer_id]); }
  $pdo->commit();
  echo '<p>Order placed. ID: '.$order_id.' Total paid: ₹'.number_format($total,2).'</p>';
  echo '<p>Discount applied: ₹'.number_format($discount,2).'. Points earned: '.$earned.'</p>';
  echo '<p><a href="index.php">Back to menu</a> | <a href="feedback.php?order_id='.$order_id.'">Give Feedback</a></p>';
} catch(Exception $e){ $pdo->rollBack(); echo 'Error: '.$e->getMessage(); } ?>