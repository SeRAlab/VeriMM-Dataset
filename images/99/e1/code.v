module ring_counter (
  input clk,
  output reg [2:0] q);

always @(posedge clk) begin
    if (q == 3'b000)
        q <= 3'b001;
    else
        q <= {q[1:0], q[2]};
end
endmodule