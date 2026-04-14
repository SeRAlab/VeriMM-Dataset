module binary_comparator(
    input       [3:0]   bin_a     ,
    input       [3:0]   bin_b     ,
    
    output  reg         gt        ,
    output  reg         eq        ,
    output  reg         lt
);
    
   always @(*) begin
       if (bin_a > bin_b) begin
           gt = 1;
           eq = 0;
           lt = 0;
       end
       else if (bin_a < bin_b) begin
           gt = 0;
           eq = 0;
           lt = 1;
       end
       else begin
           gt = 0;
           eq = 1;
           lt = 0;
       end
   end
     
endmodule