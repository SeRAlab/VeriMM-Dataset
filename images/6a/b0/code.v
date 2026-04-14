module top_module(clk,
    rst,
    load,
    D,
    Q);input clk;
  input rst;
  input load;
  input [31:0]D;
  output [31:0]Q;

  reg [31:0] reg_value;
  wire [31:0]D;
  wire [31:0]Q;
  wire clk;
  wire load;
  wire rst;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      reg_value <= 0;
    end else if (load) begin
      reg_value <= reg_value + D;
    end
  end

  assign Q = reg_value;

endmodule