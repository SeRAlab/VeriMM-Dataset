module top_module(
  input clk,
  input input1, // Added input1
  input input2, // Added input2
  output reg [n-1:0] out // Changed to reg to be used as an l-value
);parameter n = 3; // number of output signals
parameter s = 4; // number of states in the original FSM
parameter t = 6; // number of transitions in the original FSM

reg [s-1:0] state; // current state
reg [s-1:0] next_state; // next state
reg [n-1:0] output_reg; // output register

// Define the states
parameter STATE_A = 2'b00;
parameter STATE_B = 2'b01;
parameter STATE_C = 2'b10;
parameter STATE_D = 2'b11;

// Define the transitions
always @(posedge clk) begin
  state <= next_state; // Update state here to allow combinational logic to work
end

always @(posedge clk) begin
  case(state)
    STATE_A: begin
      if(input1 && input2) next_state = STATE_C;
      else if(input1) next_state = STATE_B;
      else if(input2) next_state = STATE_D;
      else next_state = STATE_A;
    end
    STATE_B: begin
      if(input1 && input2) next_state = STATE_C;
      else if(input1) next_state = STATE_A;
      else if(input2) next_state = STATE_D;
      else next_state = STATE_B;
    end
    STATE_C: begin
      if(input1 && input2) next_state = STATE_C;
      else if(input1) next_state = STATE_B;
      else if(input2) next_state = STATE_D;
      else next_state = STATE_A;
    end
    STATE_D: begin
      if(input1 && input2) next_state = STATE_C;
      else if(input1) next_state = STATE_B;
      else if(input2) next_state = STATE_A;
      else next_state = STATE_D;
    end
  endcase
end

// Define the output
always @(state) begin
  case(state)
    STATE_A: output_reg = {1'b0, 1'b0, 1'b1};
    STATE_B: output_reg = {1'b0, 1'b1, 1'b0};
    STATE_C: output_reg = {1'b1, 1'b0, 1'b0};
    STATE_D: output_reg = {1'b1, 1'b1, 1'b1};
    default: output_reg = {n{1'b0}}; // Default case to avoid latches
  endcase
end

always @(posedge clk) begin
  out <= output_reg; // Assign output after updating state
end

endmodule