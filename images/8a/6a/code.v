module top_module(
  input clk,
  input reset,
  input in1,
  input in2,
  output reg out,
  output reg [4:0] state
);// State encoding
parameter A = 5'b00001;
parameter B = 5'b00010;
parameter C = 5'b00100;
parameter D = 5'b01000;
parameter E = 5'b10000;

// State variables
reg [4:0] current_state, next_state;

// Output variable
reg next_out;

// State transition logic
always @(posedge clk, negedge reset) begin
  if (!reset) begin
    current_state <= A;
  end else begin
    current_state <= next_state;
  end
end

// Output logic
always @(current_state, in1, in2) begin
  case (current_state)
    A: begin
      next_state = (in1 & in2) ? B : A;
      next_out = 0;
    end
    B: begin
      next_state = in1 ? C : A;
      next_out = in2;
    end
    C: begin
      next_state = in1 ? D : A;
      next_out = in2;
    end
    D: begin
      next_state = in1 ? E : A;
      next_out = in2;
    end
    E: begin
      next_state = A;
      next_out = in1 | in2;
    end
    default: next_state = A;
  endcase
end

// Assign next state and output to current state and output
always @(posedge clk, negedge reset) begin
  if (!reset) begin
    state <= A;
    out <= 0;
  end else begin
    state <= next_state;
    out <= next_out;
  end
end

endmodule