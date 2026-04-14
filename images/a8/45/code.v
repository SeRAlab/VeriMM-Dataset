module top_module(
  input clk,
  input rst,
  output reg [n-1:0] state
);parameter n = 3; // number of output signals
parameter m = 2; // number of states (2^m)

reg [m-1:0] gray; // Gray code sequence

always @(*) begin
  case (gray)
    0: state = {n{1'b0}};
    1: state = {n{1'b0}} + 1'b1;
    2: state = {n{1'b0}} + 2'b01;
    3: state = {n{1'b0}} + 2'b11;
    default: state = {n{1'b0}};
  endcase
end

always @(posedge clk) begin
  if (rst) begin
    gray <= 0;
  end else begin
    gray <= gray ^ (gray >> 1);
  end
end

endmodule