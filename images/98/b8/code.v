module up_counter(clk, q);  

    input  clk;  
    output  [3:0] q;  
    reg   [3:0]  q; 
    initial q = 0;

    always @(posedge clk)
          begin
            q <= q + 1;
          end  

endmodule