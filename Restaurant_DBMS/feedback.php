<?php include 'connect.php';
if($_SERVER['REQUEST_METHOD']=='POST'){
  $order_id = (int)$_POST['order_id']; $name = $_POST['name']; $rating = (int)$_POST['rating']; $comments = $_POST['comments'];
  $stmt = $pdo->prepare('INSERT INTO feedback (order_id,customer_name,rating,comments) VALUES (?,?,?,?)');
  $stmt->execute([$order_id,$name,$rating,$comments]);
  echo '<p>Thank you for your feedback! <a href="index.php">Back</a></p>'; exit;
}
$order_id = isset($_GET['order_id']) ? (int)$_GET['order_id'] : 0;
?><!doctype html><html><head><meta charset='utf-8'><title>Feedback</title><link rel='stylesheet' href='assets/style.css'></head>
<body><div class='container'><h2>Feedback for Order #<?php echo $order_id; ?></h2>
<form method='post'>
<input type='hidden' name='order_id' value='<?php echo $order_id; ?>'>
Name: <input name='name' required><br><br>
Rating: <select name='rating'><?php for($i=5;$i>=1;$i--) echo "<option value='$i'>$i</option>"; ?></select><br><br>
Comments:<br><textarea name='comments' rows='4' cols='50'></textarea><br><br>
<button class='button' type='submit'>Submit Feedback</button>
</form></div></body></html>