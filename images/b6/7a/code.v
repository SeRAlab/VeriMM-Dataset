module binary_counter(clk, enable, count);  

    input  clk;  
    input  enable;  
    output  [1:0] count;  
    reg   [1:0]  count; 
    initial count = 0;

    always @(posedge clk)
          begin
            if (enable)
                count <= count + 1;
          end  

endmodule