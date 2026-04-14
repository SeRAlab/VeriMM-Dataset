module ring_counter (
  input clk,
  output reg [3:0] q);

always @(posedge clk) begin
    q <= {q[2:0], q[3]};
end
endmodule