module binary_subtractor(
    input       [3:0]   bin_a     ,
    input       [3:0]   bin_b     ,
    
    output  reg [3:0]   diff      ,
    output  reg         borrow_out
);
    
   always @(*) begin
       {borrow_out, diff} = bin_a - bin_b;
   end
     
endmodule