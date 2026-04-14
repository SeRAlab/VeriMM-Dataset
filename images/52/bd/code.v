module top_module(
  input clk,
  input reset,
  input [3:0] coin,
  input [3:0] selection,
  output reg dispense,
  output reg [3:0] change
);// Define the states
parameter IDLE = 2'b00;
parameter SELECT = 2'b01;
parameter DISPENSE = 2'b10;

// Define the state register and initialize to IDLE state
reg [1:0] state = IDLE;

// Define the coin and selection registers
reg [3:0] coins_inserted;
reg [3:0] product_selected;

// Define the product prices
parameter [3:0] PRODUCT_A_PRICE = 4;
parameter [3:0] PRODUCT_B_PRICE = 6;

// Define the change register
reg [3:0] change_due;

// Define the state machine
always @(posedge clk, posedge reset) begin
  if (reset) begin
    state <= IDLE;
    coins_inserted <= 4'b0;
    product_selected <= 4'b0;
    dispense <= 1'b0;
    change <= 4'b0;
  end else begin
    case (state)
      IDLE: begin
        if (coin != 4'b0) begin
          coins_inserted <= coins_inserted + coin;
          state <= SELECT;
        end
      end
      SELECT: begin
        if (selection == 4'b0001 && coins_inserted >= PRODUCT_A_PRICE) begin
          product_selected <= selection;
          coins_inserted <= coins_inserted - PRODUCT_A_PRICE;
          state <= DISPENSE;
        end else if (selection == 4'b0010 && coins_inserted >= PRODUCT_B_PRICE) begin
          product_selected <= selection;
          coins_inserted <= coins_inserted - PRODUCT_B_PRICE;
          state <= DISPENSE;
        end else if (selection != 4'b0000) begin
          state <= SELECT;
        end
      end
      DISPENSE: begin
        dispense <= 1'b1;
        change_due <= coins_inserted;
        coins_inserted <= 4'b0;
        product_selected <= 4'b0;
        state <= IDLE;
        change <= change_due;
      end
    endcase
  end
end

endmodule