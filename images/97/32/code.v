module top_module(
  input [n-1:0] in,
  output reg [n-1:0] out
);parameter n = 4; // number of states

reg [n-1:0] state; // state signals

// Connect inputs to current state signal
always @* begin
  state <= in;
end

// Priority encoder to determine which state signal should be high
always @* begin
  case(state)
    4'b0001: state <= 4'b0010; // Corrected to use 4'b prefix for 4-bit values
    4'b0010: state <= 4'b0100;
    4'b0100: state <= 4'b1000;
    4'b1000: state <= 4'b0001;
    default: state <= 4'b0001; // Default case to reset state
  endcase
end

// Output current state signal
always @* begin
  out <= state;
end

endmodule