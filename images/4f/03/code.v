module register_8bit_enable(clk, enable, d, q);  

    input  clk;  
    input  enable;  
    input  [7:0] d;  
    output  [7:0] q;  
    reg   [7:0]  q; 
    initial q = 0;

    always @(posedge clk)
          begin
            if (enable)
                q <= d;
          end  

endmodule