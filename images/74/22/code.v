module top_module(
  input wire [15:0] din,
  output reg [15:0] dout, // Change output to reg type
  input wire clk,
  input wire reset,

  input wire bclk,
  input wire [1:0] cs,
  input wire [2:0] hi_addr,
  input wire lba,
  input wire oe,
  input wire rw,
  output wire rb_wait,

  input nram_clk,
  input [15:0] nram_a,
  input [7:0] nram_din,
  output reg [7:0] nram_dout, // Change output to reg type
  input nram_we
);reg [18:0] bus_addr;
  reg [15:0] bus_data;
  reg [7:0] nram_dout_r; // Change to match output data width

  always @(posedge bclk) begin
    if (lba == 1) begin
      bus_addr <= bus_addr;
    end else begin
      bus_addr <= {hi_addr, din};
    end
  end

  always @(posedge bclk) begin
    if (cs == 2'b00 && bus_addr[18:16] == 3'b000) begin
      nram_dout_r <= nram_din;
    end
  end

  always @(posedge bclk) begin
    if (cs == 2'b00 && bus_addr[18:16] == 3'b000) begin
      nram_dout <= nram_din; // Use nram_din to set nram_dout
    end
  end

  always @(posedge bclk) begin
    if (cs == 2'b01) begin
      if (oe == 1) begin
        dout <= bus_data;
      end else begin
        dout <= 'bz;
      end
    end else begin
      dout <= 'bz;
    end
  end

  always @(posedge bclk) begin
    if (cs == 2'b00 && bus_addr[18:16] != 3'b000) begin
      bus_data <= din;
    end else if (cs == 2'b01 && oe == 0) begin
      bus_data <= nram_dout_r;
    end
  end

  assign rb_wait = 1'b1;

endmodule