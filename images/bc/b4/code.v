module top_module(
  input clk,
  input reset,
  input dispense,
  input [1:0] coin_in,
  output reg product_dispensed,
  output reg [3:0] product_count
);// Constants
  parameter PRODUCT_COST = 4'd2; // Change to be a 2-bit value
  parameter MAX_PRODUCTS = 4'd10;

  // Registers
  reg [3:0] coin_total; // Change to 4 bits to accommodate PRODUCT_COST
  reg [3:0] products_remaining;

  // Combinational logic
  wire can_dispense = (coin_total >= PRODUCT_COST) && (products_remaining > 0);

  // State machine
  reg [1:0] state;
  parameter IDLE = 2'd0, COIN_INSERTED = 2'd1, DISPENSING = 2'd2;

  always @(posedge clk) begin
    if (reset) begin
      // Reset all registers to initial state
      coin_total <= 4'd0; // Change to 4 bits
      products_remaining <= MAX_PRODUCTS;
      state <= IDLE;
      product_dispensed <= 1'b0;
    end else begin
      case (state)
        IDLE: begin
          if (coin_in != 2'd0) begin
            // Coin inserted, move to next state
            coin_total <= coin_total + {2'b00, coin_in}; // Adjust for 4 bits
            state <= COIN_INSERTED;
            product_dispensed <= 1'b0; // Reset dispense signal in IDLE
          end else if (dispense && can_dispense) begin
            // Dispense product
            products_remaining <= products_remaining - 1;
            coin_total <= coin_total - PRODUCT_COST;
            product_dispensed <= 1'b1;
          end
        end
        COIN_INSERTED: begin
          if (coin_in == 2'd0) begin
            // No more coins inserted, move back to idle
            state <= IDLE;
          end else if (dispense && can_dispense) begin
            // Dispense product
            products_remaining <= products_remaining - 1;
            coin_total <= coin_total - PRODUCT_COST; // Correct calculation
            product_dispensed <= 1'b1;
            state <= DISPENSING;
          end
        end
        DISPENSING: begin
          // Wait for dispense signal to be de-asserted
          if (!dispense) begin
            // Move back to idle
            state <= IDLE;
          end
          product_dispensed <= 1'b0; // Ensure product_dispensed is reset
        end
      endcase
    end
  end

  // Output product count
  assign product_count = products_remaining;

endmodule