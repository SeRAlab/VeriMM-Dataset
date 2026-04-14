module top_module(
   input clk_i,
   input rst_i,
   input rx_i,
   output reg [7:0] led_o,
   output reg tx_o
);parameter BIT_TIME = 5208; // number of clock cycles for one bit time
parameter START_BIT = 1'b0;
parameter STOP_BIT = 1'b1;

reg [3:0] state = 4'b0000; // state machine state
reg [7:0] data; // received data
reg [3:0] bit_count; // number of bits received
reg [BIT_TIME-1:0] bit_timer; // bit time counter

always @(posedge clk_i) begin
   if (rst_i) begin // reset
      state <= 4'b0000;
      bit_count <= 4'b0000;
      bit_timer <= 0;
      data <= 0;
      led_o <= 8'b00000000;
      tx_o <= 1'b1;
   end else begin
      case (state)
         4'b0000: begin // wait for start bit
            if (rx_i == START_BIT) begin
               bit_count <= 4'b0001;
               bit_timer <= BIT_TIME-1;
               state <= 4'b0001;
            end
         end
         4'b0001: begin // receive data bits
            if (bit_timer == 0) begin
               data[bit_count-1] <= rx_i;
               bit_count <= bit_count + 1;
               if (bit_count == 9) begin
                  state <= 4'b0010;
               end else begin
                  bit_timer <= BIT_TIME-1;
               end
            end else begin
               bit_timer <= bit_timer - 1;
            end
         end
         4'b0010: begin // wait for stop bit
            if (rx_i == STOP_BIT) begin
               led_o <= data;
               tx_o <= 1'b0;
               state <= 4'b0000;
            end else begin
               state <= 4'b0000;
            end
         end
      endcase
   end
end

endmodule