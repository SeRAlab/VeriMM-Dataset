module top_module(
  input in,
  output reg out
);parameter n = 4; // number of states

// Define states
parameter s0 = 2'b00;
parameter s1 = 2'b01;
parameter s2 = 2'b10;
parameter s3 = 2'b11;

reg [1:0] state; // state register

// Define transition conditions
always @(in) begin
  case (state)
    s0: if (in) state <= s1; else state <= s2;
    s1: if (in) state <= s3; else state <= s0;
    s2: if (in) state <= s0; else state <= s3;
    s3: if (in) state <= s2; else state <= s1;
  endcase
end

// Define output function
always @(state, in) begin
  case (state)
    s0: out <= 1'b0;
    s1: out <= 1'b1;
    s2: out <= in;
    s3: out <= ~in;
  endcase
end

endmodule