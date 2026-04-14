module top_module (
  input clk,
  input shift_left,
  input shift_right,
  input [31:0] data_in,
  output reg [31:0] q);

always @(posedge clk) begin
    if (shift_left)
        q <= {q[30:0], 1'b0};
    else if (shift_right)
        q <= {q[31], q[31:1]};
    else
        q <= data_in;
end
endmodule