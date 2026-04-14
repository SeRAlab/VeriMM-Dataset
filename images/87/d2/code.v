module binary_adder_4bit(
    input   [3:0]   a     ,
    input   [3:0]   b     ,
    
    output  [3:0]   sum   ,
    output          carry_out
);
    
   // Internal wire for carry
   wire [4:0] full_sum;
   
   // Perform the addition
   assign full_sum = a + b;
   
   // Assign the outputs
   assign sum = full_sum[3:0];
   assign carry_out = full_sum[4];
     
endmodule