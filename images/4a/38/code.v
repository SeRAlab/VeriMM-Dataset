module ring_counter(clk, reset, count);  

    input  clk;  
    input  reset;  
    output  [4:0] count;  
    reg   [4:0] count; 
    initial count = 5'b10000;

    always @(posedge clk)
        begin
            if (reset)
                count <= 5'b10000;
            else
                count <= {count[3:0], count[4]};
        end  

endmodule