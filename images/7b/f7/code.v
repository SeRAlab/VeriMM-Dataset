module top_module(
  input clk,
  input reset,
  input rxd,
  output reg ack,
  output reg [7:0] rx_data,
  output reg rx_full
);parameter IDLE = 2'd0;
  parameter START = 2'd1;
  parameter DATA = 2'd2;
  parameter STOP = 2'd3;
  
  reg [1:0] state;
  reg [2:0] bit_count;
  reg [7:0] data_bits;
  reg stop_bit;
  
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_count <= 0;
      data_bits <= 0;
      stop_bit <= 1;
      rx_full <= 0;
      ack <= 0; // Initialize ack to 0
    end else begin
      case (state)
        IDLE: begin
          if (!rxd) begin
            state <= START;
            bit_count <= 0;
            data_bits <= 0;
            stop_bit <= 1;
          end
        end
        START: begin
          if (bit_count == 0) begin
            if (!rxd) begin
              bit_count <= bit_count + 1;
            end
          end else if (bit_count < 9) begin
            data_bits[bit_count-1] <= rxd;
            bit_count <= bit_count + 1;
          end else if (bit_count == 9) begin
            stop_bit <= rxd;
            bit_count <= bit_count + 1;
          end else begin
            state <= DATA;
            bit_count <= 0;
          end
        end
        DATA: begin
          if (bit_count < 8) begin
            data_bits[bit_count] <= rxd;
            bit_count <= bit_count + 1;
          end else begin
            state <= STOP;
            bit_count <= 0;
          end
        end
        STOP: begin
          if (bit_count == 0) begin
            if (rxd == stop_bit) begin
              ack <= 1;
              rx_data <= data_bits;
              rx_full <= 1;
            end else begin
              ack <= 0;
              rx_data <= 0;
              rx_full <= 0;
            end
            state <= IDLE;
          end else begin
            bit_count <= bit_count + 1;
          end
        end
      endcase
    end
  end
  
endmodule