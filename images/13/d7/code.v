module merge_sort(input [7:0] array_in, output reg [7:0] array_out);  
  integer i, j;  
  reg [7:0] temp;  
  reg [7:0] sorted_array [0:7];  

  always @(*) begin  
    // Initialize sorted_array with input  
    for (i = 0; i < 8; i = i + 1)  
      sorted_array[i] = array_in[i];  
    
    // Merge Sort Implementation  
    for (i = 1; i < 8; i = i + 1) begin  
      for (j = 0; j < 8 - i; j = j + 1) begin  
        if (sorted_array[j] > sorted_array[j + 1]) begin  
          // Swap  
          temp = sorted_array[j];  
          sorted_array[j] = sorted_array[j + 1];  
          sorted_array[j + 1] = temp;  
        end  
      end  
    end  
    
    // Assign sorted array to output  
    for (i = 0; i < 8; i = i + 1)  
      array_out[i] = sorted_array[i];  
  end  
endmodule