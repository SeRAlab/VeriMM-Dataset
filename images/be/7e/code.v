module johnson_counter_4bit (q, clk, reset);
   input clk, reset;
   output [3:0] q;
   
   reg [3:0] q;

always @(posedge clk or posedge reset) begin
    if (reset)
    begin
        q <= 4'b0000;
    end
    else
    begin
        q <= {q[2:0], ~q[3]};
    end
end //End of always block
    
endmodule