module top_module(
  input clk, rst, load,
  input [0:0] D,
  output reg [0:0] Q  // Change 'output [0:0] Q' to 'output reg [0:0] Q'
);wire [0:0] Q_next;
  wire [0:0] Q_reset;

  assign Q_reset = 1'b0;
  assign Q_next = Q + D;

  always @(posedge clk) begin
    if (rst) begin
      Q <= Q_reset;
    end else if (load) begin
      Q <= D;
    end else begin
      Q <= Q_next;
    end
  end

endmodule