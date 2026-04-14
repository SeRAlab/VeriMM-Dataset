module top_module(
  input clk,
  input [15:0] data,
  output reg parity
);reg [3:0] count;

always @(posedge clk) begin
  count <= {count[2:0], data[0]};
  if (count == 4'b1001 || count == 4'b1011 || count == 4'b1101 || count == 4'b1111) begin
    parity <= 1;
  end else begin
    parity <= 0;
  end
end

endmodule