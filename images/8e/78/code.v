module top_module(
  input clk,
  input reset,
  input coin,
  input btn,
  input [3:0] stock,
  output reg dispense,
  output reg [3:0] led
);// Define states
parameter IDLE = 2'b00;
parameter SELECTING = 2'b01;
parameter DISPENSING = 2'b10;

// Define state register and next state logic
reg [1:0] state, next_state;
always @ (posedge clk, negedge reset) begin
  if (reset == 0) begin
    state <= IDLE;
  end else begin
    state <= next_state;
  end
end

// Define output logic
always @ (state) begin
  case (state)
    IDLE: begin
      dispense <= 0;
      led <= stock;
    end
    SELECTING: begin
      dispense <= 0;
      led <= stock;
      if (btn == 1) begin
        if (stock[0] == 1) begin
          next_state <= DISPENSING;
        end else if (stock[1] == 1) begin
          next_state <= DISPENSING;
        end else if (stock[2] == 1) begin
          next_state <= DISPENSING;
        end else if (stock[3] == 1) begin
          next_state <= DISPENSING;
        end
      end else begin
        next_state <= SELECTING;
      end
    end
    DISPENSING: begin
      dispense <= 1;
      led <= stock - {1'b0, btn};
      next_state <= IDLE;
    end
  endcase
end

// Define coin input logic
always @ (posedge clk, negedge reset) begin
  if (reset == 0) begin
    next_state <= IDLE;
  end else begin
    case (state)
      IDLE: begin
        if (coin == 1) begin
          next_state <= SELECTING;
        end else begin
          next_state <= IDLE;
        end
      end
      SELECTING: begin
        next_state <= SELECTING;
      end
      DISPENSING: begin
        next_state <= DISPENSING;
      end
    endcase
  end
end

endmodule