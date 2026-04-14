module johnson_counter_8bit (q, clk, reset);
   input clk, reset;
   output [7:0] q;
   
   reg [7:0] q;

always @(posedge clk or posedge reset) begin
    if (reset)
        q <= 8'b11111111;
    else
        q <= {~q[7], q[7:1]};
end

endmodule