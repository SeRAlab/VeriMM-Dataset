module top_module(
  input [1:0] address,
  input clk,
  input [3:0] in_port,
  input reset_n,
  output reg [31:0] readdata
);wire [3:0] data_in;
  wire [3:0] read_mux_out;
  wire clk_en;

  assign data_in = in_port;
  assign read_mux_out = {4{1'b0}} | (data_in & ((address == 2'b00) ? 4'b1111 : ((address == 2'b01) ? {2'b00, data_in[1:0]} : ((address == 2'b10) ? {2'b0, data_in[2:0]} : {1'b0, data_in[3:0]}))));

  assign clk_en = 1'b1;

  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      readdata <= 0;
    end else if (clk_en) begin
      readdata <= {32{1'b0}} | read_mux_out;
    end
  end

endmodule