module reg_8bit(clk, en, d, q);  

    input  clk;  
    input en;  
    input [7:0] d;  
    output  [7:0] q;  
    reg   [7:0]  q; 

    always @(posedge clk)
          begin
            if (en)
                q <= d;
          end  

endmodule