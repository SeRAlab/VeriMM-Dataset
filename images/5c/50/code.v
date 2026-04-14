module top_module(
  input [1:0] address,
  input clk,
  input in_port,
  input reset_n,
  output reg [31:0] readdata
);wire chip_select;
  assign chip_select = (address == 2'b00); // Assuming chip select is active when address is 00

  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      readdata <= 0;
    end else if (chip_select) begin
      readdata <= in_port;
    end
  end

endmodule