module quicksort(input [15:0] unsorted, output [15:0] sorted);  
  wire [3:0] a, b, c, d;  
  assign a = unsorted[15:12];  
  assign b = unsorted[11:8];  
  assign c = unsorted[7:4];  
  assign d = unsorted[3:0];  

  wire [3:0] min1, min2, min3, max1, max2, max3;  
  assign min1 = (a < b) ? a : b;  
  assign min2 = (c < d) ? c : d;  
  assign max1 = (a > b) ? a : b;  
  assign max2 = (c > d) ? c : d;  
  assign sorted = {max1, max2, min1, min2};  
endmodule