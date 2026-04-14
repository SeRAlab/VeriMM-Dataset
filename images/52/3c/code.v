module top_module(
  input [1:0] address,
  input chipselect,
  input clk,
  input reset_n,
  input write_n,
  input [9:0] writedata,
  output reg [9:0] out_port,
  output reg [31:0] readdata
);reg [9:0] data_out;
  wire [9:0] read_mux_out;
  wire clk_en;

  assign clk_en = 1;

  assign read_mux_out = {10{(address == 0)}} & data_out;

  always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin
      data_out <= 0;
    end else begin
      if(chipselect && ~write_n && (address == 0)) begin
        data_out <= writedata;
      end
    end
  end

  assign out_port = data_out;
  assign readdata = {32'b0, read_mux_out};

endmodule