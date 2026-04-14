module top_module(
  input [n-1:0] data_in,
  input clk,
  output [n-1:0] data_out
);parameter n = 8; // number of bits in data
parameter baud_rate = 9600; // baud rate in bits per second

reg [n-1:0] tx_data;
reg [n-1:0] rx_data;
reg tx_enable;
reg rx_enable;
reg tx_busy;
reg rx_busy;
reg [7:0] tx_counter;
reg [7:0] rx_counter;
reg tx_bit;
reg rx_bit;
reg [15:0] carrier_counter;
reg carrier_out;

assign data_out = rx_data;

always @(posedge clk) begin
  // Transmitting data
  if (tx_enable) begin
    if (tx_busy) begin
      if (tx_counter == baud_rate/2 - 1) begin
        carrier_counter <= 0;
        tx_bit <= tx_data[tx_counter];
        tx_counter <= 0;
      end else begin
        carrier_counter <= carrier_counter + 1;
        if (carrier_counter == baud_rate/2) begin
          carrier_out <= ~carrier_out;
          tx_counter <= tx_counter + 1;
        end
      end
    end else begin
      if (tx_counter == n - 1) begin
        tx_busy <= 1;
        tx_counter <= 0;
      end else begin
        tx_counter <= tx_counter + 1;
      end
    end
  end else begin
    tx_busy <= 0;
    tx_counter <= 0;
    carrier_out <= 0;
  end
  
  // Receiving data
  if (rx_enable) begin
    if (rx_busy) begin
      if (rx_counter == baud_rate/2 - 1) begin
        rx_data[rx_counter] <= rx_bit;
        rx_counter <= 0;
      end else begin
        rx_counter <= rx_counter + 1;
      end
    end else begin
      if (carrier_out) begin
        rx_busy <= 1;
        rx_counter <= 0;
      end
    end
  end else begin
    rx_busy <= 0;
    rx_counter <= 0;
  end
end

assign tx_enable = (tx_busy == 0) && (data_in != 0);
assign rx_enable = (rx_busy == 0);

always @(posedge clk) begin
  if (tx_busy) begin
    if (tx_bit) begin
      carrier_out <= ~carrier_out;
    end
  end
end

endmodule