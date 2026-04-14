module top_module(
  input [1:0] address,
  input chipselect,
  input clk,
  input in_port,
  input reset_n,
  input write_n,
  input [31:0] writedata,
  output irq,
  output [31:0] readdata
);reg [31:0] mem [3:0];
  reg [31:0] read_mux_out;
  reg [31:0] readdata_reg;
  reg irq_mask;
  wire clk_en;

  assign clk_en = 1;

  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      readdata_reg <= 0;
      irq_mask <= 0;
    end else if (clk_en) begin
      readdata_reg <= read_mux_out;
    end
  end

  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      mem[0] <= 0;
      mem[1] <= 0;
      mem[2] <= 0;
      mem[3] <= 0;
    end else if (chipselect && ~write_n) begin
      mem[address] <= writedata;
    end
  end

  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      read_mux_out <= 0;
    end else begin
      case (address)
        2'b00: read_mux_out <= mem[0];
        2'b01: read_mux_out <= mem[1];
        2'b10: read_mux_out <= irq_mask;
        2'b11: read_mux_out <= mem[3];
      endcase
    end
  end

  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      irq_mask <= 0;
    end else if (chipselect && write_n && (address == 2)) begin
      irq_mask <= writedata;
    end
  end

  assign irq = |(in_port & irq_mask);

  assign readdata = readdata_reg;

endmodule