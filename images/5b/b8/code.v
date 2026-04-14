module top_module(input clk, input rst, input [3:0] din, output reg [3:0] dout);reg [3:0] reg_out;
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      reg_out <= 4'b0;
    end else begin
      reg_out <= din;
    end
  end
  assign dout = reg_out;
endmodule