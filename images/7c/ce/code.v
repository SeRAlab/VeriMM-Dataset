module top_module(
  input clk,
  input rst,
  input [143:0] flit0c,
  input [143:0] flit1c,
  input [143:0] flitl0,
  input [143:0] flitl1,
  output reg port0_co,
  output reg port1_co,
  output reg portl0_co,
  output reg portl1_co,
  output reg ack0,
  output reg ack1
);always @(posedge clk) begin
    if (rst) begin
      port0_co <= 0;
      port1_co <= 0;
      portl0_co <= 0;
      portl1_co <= 0;
      ack0 <= 0;
      ack1 <= 0;
    end else begin
      port0_co <= flit0c;
      port1_co <= flit1c;
      portl0_co <= flitl0;
      portl1_co <= flitl1;
      ack0 <= (flitl0 != 0);
      ack1 <= (flitl1 != 0);
    end
  end

endmodule