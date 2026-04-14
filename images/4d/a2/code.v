module top_module(
  input [2:0] address,
  input chipselect,
  input clk,
  input reset_n,
  input write_n,
  input [31:0] writedata,
  output reg [7:0] out_port,
  output reg [31:0] readdata
);reg [7:0] data_out;
  reg [7:0] read_mux_out;
  reg wr_strobe;
  reg clk_en;

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      data_out <= 8'b0;
    end else if (clk_en) begin
      if (!write_n) begin
        case (address)
          3'b000: data_out[7:0] <= writedata[7:0];
          default: data_out[7:0] <= data_out[7:0];
        endcase
      end
    end
  end

  always @(*) begin
    case (address)
      3'b000: read_mux_out[7:0] = data_out[7:0];
      default: read_mux_out[7:0] = 8'b0;
    endcase
  end

  assign out_port = data_out;

  always @(posedge clk) begin
    if (chipselect && !write_n) begin
      wr_strobe <= 1;
    end else begin
      wr_strobe <= 0;
    end
    clk_en <= chipselect;
  end

  assign readdata = {32'b0, read_mux_out};

endmodule