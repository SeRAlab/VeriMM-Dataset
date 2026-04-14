module binary_adder(
    input       [3:0]   bin_a     ,
    input       [3:0]   bin_b     ,
    
    output  reg [3:0]   sum       ,
    output  reg         carry_out
);
    
   always @(*) begin
       {carry_out, sum} = bin_a + bin_b;
   end
     
endmodule