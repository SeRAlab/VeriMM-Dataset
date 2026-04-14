module top_module(
  input clk,
  input reset,
  input [3:0] selection,
  input [7:0] payment,
  output reg [3:0] dispensing,
  output reg [7:0] change
);// Define the three states
  parameter IDLE = 2'b00;
  parameter SELECTION = 2'b01;
  parameter DISPENSING = 2'b10;

  // Define the state register and initialize it to IDLE
  reg [1:0] state = IDLE;

  // Define the item price and initialize it to 50 cents
  reg [7:0] item_price = 8'd50;

  // Define the amount of money inserted by the user
  reg [7:0] inserted_money = 8'd0;

  always @(posedge clk) begin
    if (reset) begin
      // Reset the state and inserted_money registers
      state <= IDLE;
      inserted_money <= 8'd0;
    end else begin
      case (state)
        IDLE: begin
          // Wait for the user to make a selection
          if (selection != 4'b0000) begin
            // Transition to the SELECTION state and set the item price
            state <= SELECTION;
            item_price <= (selection == 4'b0001) ? 8'd50 : 8'd75;
          end
        end
        SELECTION: begin
          // Wait for the user to insert enough money
          if (inserted_money >= item_price) begin
            // Dispense the item and return change
            dispensing <= selection;
            change <= inserted_money - item_price;
            // Transition to the DISPENSING state
            state <= DISPENSING;
          end else if (payment != 8'd0) begin
            // Add the inserted money to the register
            inserted_money <= inserted_money + payment;
          end
        end
        DISPENSING: begin
          // Wait for the item to finish dispensing
          if (dispensing == 4'b0000) begin
            // Transition back to the IDLE state
            state <= IDLE;
            // Reset the item price and inserted_money registers
            item_price <= 8'd50;
            inserted_money <= 8'd0;
          end
        end
      endcase
    end
  end

endmodule