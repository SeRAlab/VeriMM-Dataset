module top_module(
  // inputs:
  input [1:0] address,
  input chipselect,
  input clk,
  input reset_n,
  input write_n,
  input [31:0] writedata,

  // outputs:
  output reg [31:0] out_port,
  output reg [31:0] readdata
);wire clk_en;
  reg [31:0] data_out;
  
  assign clk_en = 1;
  
  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      data_out <= 0;
    end else if (chipselect && ~write_n) begin
      case (address)
        2'b00: data_out <= writedata + data_out;
        2'b01: data_out <= data_out - writedata;
        2'b10: data_out <= writedata & data_out;
        2'b11: data_out <= writedata | data_out;
      endcase
    end
  end

  assign read_mux_out = {32{~address[1]}} & data_out;
  assign out_port = data_out;
  assign readdata = {1'b0, read_mux_out};

endmodule