<?php include 'connect.php'; ?>
<!doctype html><html><head><meta charset='utf-8'><title>Restaurant - Menu</title><link rel='stylesheet' href='assets/style.css'></head>
<body><div class='container'>
<h1>Restaurant Menu</h1>
<p><a class='button' href='admin/login.php'>Admin Dashboard</a></p>
<form method='post' action='order.php'>
<table class='menu-table'><tr><th>Item</th><th>Category</th><th>Price</th><th>Qty</th></tr>
<?php
$stmt = $pdo->query("SELECT m.*, b.name as branch_name FROM menu_items m LEFT JOIN branches b ON m.branch_id=b.id ORDER BY m.category, m.name");
while($row=$stmt->fetch()){
  echo "<tr><td>".htmlspecialchars($row['name'])."<br><small>".htmlspecialchars($row['branch_name'])."</small></td>";
  echo "<td>".htmlspecialchars($row['category'])."</td>";
  echo "<td>₹".number_format($row['price'],2)."</td>";
  echo "<td><input name='qty[{$row['id']}]' type='number' min='0' value='0' style='width:70px'></td></tr>";
}
?>
</table>
<p>Name: <input name='customer_name' required> Email (optional): <input name='email'></p>
<p><label><input type='checkbox' name='use_points' value='1'> Apply reward points if available</label></p>
<button class='button' type='submit'>Place Order</button>
</form></div></body></html>