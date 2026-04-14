module top_module(
  input clk,
  input reset,
  input coin_5,
  input coin_10,
  input coin_25,
  output reg product_dispensed
);// Define the states
  localparam IDLE = 2'b00;
  localparam ACCEPTING = 2'b01;
  localparam DISPENSING = 2'b10;

  // Define the current state and the current amount
  reg [1:0] state = IDLE;
  reg [5:0] current_amount = 0;

  // Define the state transition logic
  always @(posedge clk, negedge reset) begin
    if (reset == 1'b0) begin
      state <= IDLE;
      current_amount <= 0;
      product_dispensed <= 0;
    end else begin
      case (state)
        IDLE: begin
          if (coin_5) begin
            current_amount <= current_amount + 5;
            state <= ACCEPTING;
          end else if (coin_10) begin
            current_amount <= current_amount + 10;
            state <= ACCEPTING;
          end else if (coin_25) begin
            current_amount <= current_amount + 25;
            state <= ACCEPTING;
          end
        end
        ACCEPTING: begin
          if (current_amount >= 50) begin
            state <= DISPENSING;
          end else if (coin_5) begin
            current_amount <= current_amount + 5;
          end else if (coin_10) begin
            current_amount <= current_amount + 10;
          end else if (coin_25) begin
            current_amount <= current_amount + 25;
          end else begin
            state <= IDLE;
          end
        end
        DISPENSING: begin
          product_dispensed <= 1;
          state <= IDLE;
          current_amount <= current_amount - 50;
        end
      endcase
    end
  end

endmodule