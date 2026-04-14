module top_module(
  input clk,
  input reset,
  input [31:0] data_in,
  input [99:0] rx_packet,
  output reg [31:0] data_out,  // changed wire to reg
  output [99:0] tx_packet,
  output tx_busy
);reg [31:0] data_buffer;
  reg [99:0] tx_packet_reg;
  reg tx_busy_reg;
  wire [31:0] rx_data;
  wire [31:0] rx_checksum;
  wire [31:0] calculated_checksum;

  assign tx_packet = tx_packet_reg;
  assign tx_busy = tx_busy_reg;
  
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      data_buffer <= 32'h0;
      tx_packet_reg <= 100'h0;
      tx_busy_reg <= 1'b0;
      data_out <= 32'h0;  // Initialize data_out in reset
    end else begin
      if (!tx_busy_reg) begin
        data_buffer <= data_in;
        tx_packet_reg[31:0] <= data_in;
        tx_packet_reg[63:32] <= ~data_in;
        tx_packet_reg[95:64] <= data_in ^ 32'hAAAAAAAA;
        tx_packet_reg[99:96] <= 4'hF;
        tx_busy_reg <= 1'b1;
      end else begin
        tx_busy_reg <= 1'b0;
      end
    end
  end

  assign rx_data = rx_packet[31:0];
  assign rx_checksum = rx_packet[63:32];
  assign calculated_checksum = rx_data ^ rx_packet[95:64] ^ 32'hAAAAAAAA;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      data_out <= 32'h0;
    end else begin
      if (rx_checksum == calculated_checksum) begin
        data_out <= rx_data;
      end
    end
  end

endmodule