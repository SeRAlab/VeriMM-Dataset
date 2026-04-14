module top_module(
  input clk,
  input reset,
  input coin_inserted,
  input [1:0] item_selected,
  input item_dispensed,
  output reg dispense_item,
  output reg return_coin
);// Define the states
  parameter IDLE = 2'b00;
  parameter ITEM_SELECTED = 2'b01;
  parameter ITEM_DISPENSED = 2'b10;

  // Define the current state
  reg [1:0] state;

  // Define the next state
  reg [1:0] next_state;

  // Define the state transition logic
  always @ (posedge clk, posedge reset) begin
    if (reset) begin
      state <= IDLE;
    end else begin
      state <= next_state;
    end
  end

  // Define the state output logic
  always @ (state, coin_inserted, item_selected, item_dispensed) begin
    case (state)
      IDLE: begin
        dispense_item <= 0;
        return_coin <= 0;
        if (coin_inserted && item_selected != 2'b00) begin
          next_state <= ITEM_SELECTED;
        end else begin
          next_state <= IDLE;
        end
      end
      ITEM_SELECTED: begin
        dispense_item <= 1;
        return_coin <= 0;
        if (item_dispensed) begin
          next_state <= ITEM_DISPENSED;
        end else begin
          next_state <= ITEM_SELECTED;
        end
      end
      ITEM_DISPENSED: begin
        dispense_item <= 0;
        return_coin <= 1;
        next_state <= IDLE;
      end
      default: begin
        dispense_item <= 0;
        return_coin <= 0;
        next_state <= IDLE;
      end
    endcase
  end

endmodule