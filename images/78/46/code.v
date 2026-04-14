module top_module(
  input clk, // clock signal
  input rst, // reset signal
  output reg [n-1:0] state // state signals
);parameter n = 4; // number of states in the state machine

// Define the sequence of states as a set of parameters
parameter s1 = 4'b0001;
parameter s2 = 4'b0010;
parameter s3 = 4'b0100;
parameter s4 = 4'b1000;

// Define the output values of the state signals based on the current state and the clock and reset signals
always @(posedge clk or posedge rst) begin
  if (rst) begin
    state <= s1;
  end else begin
    case(state)
      s1: state <= s2;
      s2: state <= s3;
      s3: state <= s4;
      s4: state <= s1;
      default: state <= s1; // Added default case for safety
    endcase
  end
end

endmodule