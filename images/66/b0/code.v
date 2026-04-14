module top_module(
  input clk,
  input rst,
  // other input signals required by the FSM
  output reg [n-1:0] out
);parameter n = 2; // number of output signals
parameter m = 4; // number of states in the FSM

// Define the states using state encoding compression
parameter STATE_00 = 2'b00;
parameter STATE_01 = 2'b01;
parameter STATE_10 = 2'b10;
parameter STATE_11 = 2'b11;

// Define the transitions between states
reg [1:0] state, next_state;
always @(posedge clk) begin
  if (rst) begin
    state <= STATE_00;
  end else begin
    state <= next_state;
  end
end

// Define the output signals for each state
always @(*) begin
  case (state)
    STATE_00: begin
      out = {n{1'b0}};
      next_state = STATE_01;
    end
    STATE_01: begin
      out = {n{1'b1}};
      next_state = STATE_10;
    end
    STATE_10: begin
      out = {n{1'b0}};
      next_state = STATE_11;
    end
    STATE_11: begin
      out = {n{1'b1}};
      next_state = STATE_00;
    end
    default: begin
      out = {n{1'b0}};
      next_state = STATE_00;
    end
  endcase
end

endmodule