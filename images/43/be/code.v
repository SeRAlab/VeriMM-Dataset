module johnson_counter(clk, reset, count);  

    input  clk;  
    input  reset;  
    output  [1:0] count;  
    reg   [1:0] count; 
    initial count = 2'b00;

    always @(posedge clk)
        begin
            if (reset)
                count <= 2'b00;
            else
                count <= {~count[0], count[1]};
        end  

endmodule