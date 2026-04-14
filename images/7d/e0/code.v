module top_module(
  input clk,
  input rst,
  input [7:0] tx_data,
  input tx_valid,
  input rx_ready,
  output reg tx_ready,
  output reg [7:0] rx_data,
  output reg rx_valid
);reg [3:0] state;
  reg [7:0] shift_reg;
  reg [3:0] bit_cnt;
  reg [7:0] crc;

  localparam IDLE = 4'h0,
            TX_START = 4'h1,
            TX_DATA = 4'h2,
            TX_CRC = 4'h3,
            RX_START = 4'h4,
            RX_DATA = 4'h5,
            RX_CRC = 4'h6;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      state <= IDLE;
      tx_ready <= 1'b0;
      rx_valid <= 1'b0;
    end else begin
      case (state)
        IDLE: begin
          if (tx_valid && rx_ready) begin
            state <= TX_START;
            tx_ready <= 1'b1;
          end else if (rx_ready) begin
            state <= RX_START;
          end
        end

        TX_START: begin
          state <= TX_DATA;
          shift_reg <= tx_data;
          bit_cnt <= 4'h8;
          crc <= 8'h0;
        end

        TX_DATA: begin
          crc <= crc ^ shift_reg;
          shift_reg <= shift_reg >> 1;
          bit_cnt <= bit_cnt - 1;
          if (bit_cnt == 0) begin
            state <= TX_CRC;
          end
        end

        TX_CRC: begin
          shift_reg <= crc;
          bit_cnt <= 4'h8;
          state <= IDLE;
        end

        RX_START: begin
          state <= RX_DATA;
          shift_reg <= 8'h0;
          bit_cnt <= 4'h8;
          crc <= 8'h0;
        end

        RX_DATA: begin
          shift_reg <= (shift_reg >> 1) | (rx_data << 7);
          crc <= crc ^ shift_reg;
          bit_cnt <= bit_cnt - 1;
          if (bit_cnt == 0) begin
            state <= RX_CRC;
          end
        end

        RX_CRC: begin
          if (crc == rx_data) begin
            rx_valid <= 1'b1;
          end else begin
            rx_valid <= 1'b0;
          end
          state <= IDLE;
        end

      endcase
    end
  end

endmodule