$Data = Get-Process

# Start of CSS
$CSS = 

" 
<style>
table, th, td 
{
    border-collapse: collapse;
    padding: 15px;
    
} 
th {
    background-color: #00008B;
    color: Gold;
  }
tr:nth-child(even) {background-color: #D3D3D3;}
  </style>  
"
# End of CSS

# Start of JavaScript
$JavaScriptFunction = 
'
<script>
function sortTable(n) {
  var table, rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
  table = document.getElementById("myTable");
  switching = true;
  //Set the sorting direction to ascending:
  dir = "asc"; 
  /*Make a loop that will continue until
  no switching has been done:*/
  while (switching) {
    //start by saying: no switching is done:
    switching = false;
    rows = table.rows;
    /*Loop through all table rows (except the
    first, which contains table headers):*/
    for (i = 1; i < (rows.length - 1); i++) {
      //start by saying there should be no switching:
      shouldSwitch = false;
      /*Get the two elements you want to compare,
      one from current row and one from the next:*/
      x = rows[i].getElementsByTagName("TD")[n];
      y = rows[i + 1].getElementsByTagName("TD")[n];
      /*check if the two rows should switch place,
      based on the direction, asc or desc:*/
      if (dir == "asc") {
        if (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()) {
          //if so, mark as a switch and break the loop:
          shouldSwitch= true;
          break;
        }
      } else if (dir == "desc") {
        if (x.innerHTML.toLowerCase() < y.innerHTML.toLowerCase()) {
          //if so, mark as a switch and break the loop:
          shouldSwitch = true;
          break;
        }
      }
    }
    if (shouldSwitch) {
      /*If a switch has been marked, make the switch
      and mark that a switch has been done:*/
      rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
      switching = true;
      //Each time a switch is done, increase this count by 1:
      switchcount ++;      
    } else {
      /*If no switching has been done AND the direction is "asc",
      set the direction to "desc" and run the while loop again.*/
      if (switchcount == 0 && dir == "asc") {
        dir = "desc";
        switching = true;
      }
    }
  }
}
</script>
  '
  #End of JavaScript

  #Write host for debug
  Write-Host "Javascript done"

$Data | Convertto-HTML -Head $CSS -PostContent $JavaScriptFunction | Out-File "./data.html"

  #Write host for debug
  Write-Host "HTML File Created"
#Find and replace table headers to make javascript work
(Get-Content "./data.html").Replace('<table>', '<table id="myTable">') | Set-Content "./data.html" -Force
(Get-Content "./data.html").Replace('<th>Name</th>', '<th onclick="sortTable(0)">Name</th>') | Set-Content "./data.html" -Force
(Get-Content "./data.html").Replace('<th>Id</th>', '<th onclick="sortTable(1)">Id</th>') | Set-Content "./data.html" -Force

Write-Host "Entire script has run"
  
