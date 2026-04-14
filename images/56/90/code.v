module up_counter(clk, reset, count);

    input  clk;  
    input  reset;  
    output  [7:0] count;  
    reg    [7:0] count; 
    initial count = 0;

    always @(posedge clk)
          begin
            if (reset) 
                count <= 0;
            else
                count <= count + 1;
          end  

endmodule