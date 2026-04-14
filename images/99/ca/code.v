module top_module(
  input clk,
  input reset,
  input coin_insert,
  input product_select,
  output reg dispense,
  output reg [3:0] display
);parameter IDLE = 2'b00;
  parameter SELECTING = 2'b01;
  parameter DISPENSING = 2'b10;
  parameter RESETTING = 2'b11;

  reg [1:0] state;
  reg [2:0] coins_inserted;
  reg [1:0] product_selected;

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      coins_inserted <= 0;
      product_selected <= 0;
      dispense <= 0;
      display <= 0;
    end else begin
      case (state)
        IDLE: begin
          if (coin_insert) begin
            coins_inserted <= coins_inserted + 1;
            state <= SELECTING;
          end
        end
        SELECTING: begin
          if (product_select) begin
            product_selected <= product_selected + 1;
            if (coins_inserted >= product_selected) begin
              coins_inserted <= coins_inserted - product_selected;
              dispense <= 1;
              state <= DISPENSING;
            end else begin
              state <= SELECTING;
            end
          end
        end
        DISPENSING: begin
          dispense <= 0;
          display <= product_selected;
          state <= RESETTING;
        end
        RESETTING: begin
          if (!dispense) begin
            product_selected <= 0;
            state <= IDLE;
          end
        end
      endcase
    end
  end
endmodule