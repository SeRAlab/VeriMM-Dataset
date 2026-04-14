module binary_counter(clk, enable, count);

    input  clk;  
    input  enable;  
    output [2:0] count;  
    reg    [2:0] count; 
    initial count = 0;

    always @(posedge clk)
        begin
            if (enable)
                count <= count + 1;
            else
                count <= count;
        end  

endmodule