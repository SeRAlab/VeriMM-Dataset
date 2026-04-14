module sync_reset_counter(clk, reset, count);  

    input  clk;  
    input  reset;  
    output  [1:0] count;  
    reg   [1:0]  count; 
    initial count = 0;

    always @(posedge clk)
          begin
            if (reset)
                count <= 0;
            else
                count <= count + 1;
          end  

endmodule