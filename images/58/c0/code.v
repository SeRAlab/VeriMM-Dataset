module top_module(
  input [1:0] address,
  input chipselect,
  input clk,
  input reset_n,
  input write_n,
  input [31:0] writedata,
  output reg [7:0] out_port,
  output reg [31:0] readdata
);reg [7:0] data_reg;

  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      data_reg <= 8'h00;
    end else if (chipselect && ~write_n) begin
      case (address)
        2'b00: data_reg[7:0] <= writedata[7:0];
        default: data_reg <= data_reg;
      endcase
    end
  end

  always @(*) begin
    case (address)
      2'b00: out_port = data_reg;
      default: out_port = 8'h00;
    endcase
    readdata = {24'h00, data_reg};
  end

endmodule