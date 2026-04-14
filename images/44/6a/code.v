module top_module(
  input clk,
  input rst,
  input load,
  input [3:0] D,
  output [3:0] Q
);reg [3:0] reg_out;
  wire [3:0] add_out;

  always @(posedge clk, posedge rst) begin
    if (rst) begin
      reg_out <= 4'b0;
    end else if (load) begin
      reg_out <= D;
    end else begin
      reg_out <= reg_out + D;
    end
  end

  assign Q = reg_out;

endmodule