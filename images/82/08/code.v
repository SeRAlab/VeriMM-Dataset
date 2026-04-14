module top_module(
  input clk,
  input reset,
  input coin_input,
  input button_input,
  output reg display_output,
  output reg product_output
);parameter IDLE = 2'b00;
  parameter WAITING_FOR_COINS = 2'b01;
  parameter DISPENSING = 2'b10;
  
  reg [1:0] state, next_state;
  reg [3:0] price = 4'b0010;
  reg [3:0] coins_inserted;
  
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      coins_inserted <= 0;
      display_output <= price;
      product_output <= 0;
    end else begin
      state <= next_state;
      case (state)
        IDLE: begin
          if (coin_input) begin
            coins_inserted <= coins_inserted + 1;
            next_state <= WAITING_FOR_COINS;
          end else begin
            next_state <= IDLE;
          end
        end
        WAITING_FOR_COINS: begin
          if (coin_input) begin
            coins_inserted <= coins_inserted + 1;
            next_state <= WAITING_FOR_COINS;
          end else if (button_input && coins_inserted >= price) begin
            coins_inserted <= coins_inserted - price;
            next_state <= DISPENSING;
          end else begin
            next_state <= WAITING_FOR_COINS;
          end
        end
        DISPENSING: begin
          product_output <= 1;
          next_state <= IDLE;
        end
      endcase
    end
  end

endmodule