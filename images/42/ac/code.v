module top_module(
  input clk,
  input reset,
  input coin,
  input [1:0] selection,
  output reg dispense
);parameter IDLE = 2'b00, COIN_INSERTED = 2'b01, PRODUCT_SELECTED = 2'b10;
parameter PRICE_1 = 2'b00, PRICE_1_5 = 2'b01, PRICE_2 = 2'b10;

reg [1:0] state, price;
reg dispense_temp;

always @(posedge clk) begin
  if (reset) begin
    state <= IDLE;
    price <= PRICE_1;
    dispense_temp <= 1'b0;
  end
  else begin
    case (state)
      IDLE: begin
        if (coin) begin
          state <= COIN_INSERTED;
        end
        else if (selection != 2'b00) begin
          state <= PRODUCT_SELECTED;
          case (selection)
            2'b01: price <= PRICE_1;
            2'b10: price <= PRICE_1_5;
            2'b11: price <= PRICE_2;
          endcase
        end
      end
      COIN_INSERTED: begin
        if (coin) begin
          price <= price + 1;
        end
        else if (price <= PRICE_1_5) begin
          state <= PRODUCT_SELECTED;
        end
      end
      PRODUCT_SELECTED: begin
        if (coin && (price < PRICE_2)) begin
          price <= price + 1;
        end
        else if (coin && (price == PRICE_2)) begin
          dispense_temp <= 1'b1;
          state <= IDLE;
        end
        else if (selection != 2'b00) begin
          case (selection)
            2'b01: begin
              if (price >= PRICE_1) begin
                dispense_temp <= 1'b1;
                state <= IDLE;
              end
            end
            2'b10: begin
              if (price >= PRICE_1_5) begin
                dispense_temp <= 1'b1;
                state <= IDLE;
              end
            end
            2'b11: begin
              if (price >= PRICE_2) begin
                dispense_temp <= 1'b1;
                state <= IDLE;
              end
            end
          endcase
        end
      end
    endcase
  end
end

always @(posedge clk) begin
  if (reset) begin
    dispense <= 1'b0;
  end
  else begin
    dispense <= dispense_temp;
    dispense_temp <= 1'b0;
  end
end

endmodule