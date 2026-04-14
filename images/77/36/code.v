module top_module(
  input clk,
  input reset,
  input coin_inserted,
  input item_selected,
  input item_dispensed,
  output reg dispense_item,
  output reg return_change,
  output reg item_not_available,
  output reg ready_to_dispense
);reg state, next_state;

  localparam IDLE = 2'b00, DISPENSE = 2'b01, RETURN_CHANGE = 2'b10, ITEM_NOT_AVAILABLE = 2'b11;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
    end else begin
      state <= next_state;
    end
  end

  always @(*) begin
    next_state = state;
    dispense_item = 0;
    return_change = 0;
    item_not_available = 0;
    ready_to_dispense = 0;

    case (state)
      IDLE: begin
        if (coin_inserted && item_selected) begin
          next_state = DISPENSE;
        end else if (item_selected) begin
          next_state = ITEM_NOT_AVAILABLE;
        end else if (coin_inserted) begin
          next_state = RETURN_CHANGE;
        end
      end
      DISPENSE: begin
        dispense_item = 1;
        next_state = IDLE;
      end
      RETURN_CHANGE: begin
        return_change = ~item_dispensed;
        next_state = IDLE;
      end
      ITEM_NOT_AVAILABLE: begin
        item_not_available = ~item_dispensed;
        ready_to_dispense = item_dispensed;
        next_state = IDLE;
      end
    endcase
  end

endmodule