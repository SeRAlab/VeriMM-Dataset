module down_counter(clk, enable, count);  

    input  clk;  
    input  enable;  
    output  [2:0] count;  
    reg   [2:0]  count; 
    initial count = 7;

    always @(negedge clk)
          begin
            if (enable)
                count <= count - 1;
          end  

endmodule