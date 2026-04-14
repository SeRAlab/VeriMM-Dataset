module top_module(
  input clk,
  input UART_RX,
  output reg [7:0] data,
  output reg insend
);// Add implementation for Rs232Rx module
  // This is a simple placeholder implementation. You need to replace it with actual UART receive logic.
  reg [3:0] bit_count;
  reg [7:0] rx_buffer;
  
  always @(posedge clk) begin
    if (UART_RX == 0) begin // Start bit detected
      bit_count <= 0;
      insend <= 1;
    end else if (insend) begin
      if (bit_count < 8) begin
        rx_buffer[bit_count] <= UART_RX; // Sample data
        bit_count <= bit_count + 1;
      end else begin
        data <= rx_buffer; // Complete byte received
        insend <= 0;
      end
    end else begin
      insend <= 0;
    end
  end
endmodule