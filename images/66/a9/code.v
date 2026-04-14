module verified_d_flip_flop(clk, d, q);  

    input  clk;  
    input d;  
    output  q;  
    reg   q; 

    always @(posedge clk)
          begin
            q <= d;
          end  

endmodule