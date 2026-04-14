module counter(clk, reset, count);  

    input  clk;  
    input  reset;  
    output  [3:0] count;  
    reg   [3:0] count; 
    initial count = 0;

    always @(posedge clk)
        begin
            if (reset)
                count <= 0;
            else
                count <= count + 1;
        end  

endmodule