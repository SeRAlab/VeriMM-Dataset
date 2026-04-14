module top_module(
  input [data_width-1:0] data,
  input clk,
  input rst,
  output [tx_width-1:0] tx,
  input [rx_width-1:0] rx,
  output [data_width-1:0] data_out
);parameter data_width = 8; // number of bits in data signal
parameter tx_width = 16; // number of bits in transmitter output signal
parameter rx_width = 16; // number of bits in receiver input signal

// Transmitter module
reg [data_width-1:0] modulated_data;
reg [1:0] tx_state;  // Changed from 'state' to 'tx_state'
wire [1:0] tx_next_state;  // Changed from 'next_state' to 'tx_next_state'

assign tx_next_state = (tx_state == 2'b00) ? 2'b01 :
                   (tx_state == 2'b01) ? 2'b10 :
                   (tx_state == 2'b10) ? 2'b00 : 2'b00;

always @(posedge clk) begin
  if (rst) begin
    tx_state <= 2'b00;
    modulated_data <= 0;
  end else begin
    tx_state <= tx_next_state;
    case(tx_state)
      2'b00: modulated_data <= data;
      2'b01: modulated_data <= ~data;
      2'b10: modulated_data <= 0;
    endcase
  end
end

assign tx = {modulated_data, ~modulated_data};

// Receiver module
reg [data_width-1:0] demodulated_data;
reg [1:0] rx_state;  // Changed from 'state' to 'rx_state'
wire [1:0] rx_next_state;  // Changed from 'next_state' to 'rx_next_state'

assign rx_next_state = (rx_state == 2'b00) ? 2'b01 :
                   (rx_state == 2'b01) ? 2'b10 :
                   (rx_state == 2'b10) ? 2'b00 : 2'b00;

always @(posedge clk) begin
  if (rst) begin
    rx_state <= 2'b00;
    demodulated_data <= 0;
  end else begin
    rx_state <= rx_next_state;
    case(rx_state)
      2'b00: demodulated_data <= {rx[7:0], ~rx[7:0]};
      2'b01: demodulated_data <= {rx[15:8], ~rx[15:8]};
      2'b10: demodulated_data <= 0;
    endcase
  end
end

assign data_out = demodulated_data;

endmodule