module johnson_counter(clk, q);

    input  clk;  
    output [4:0] q;  
    reg    [4:0] q; 
    initial q = 5'b00001;

    always @(posedge clk)
        begin
            q <= {q[3:0], ~q[4]};
        end  

endmodule