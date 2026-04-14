module top_module(
  input clk,
  input rst,
  output reg [n-1:0] out
);parameter n = 4; // number of bits in the counter

// define the sequence of states as a set of binary values
reg [n-1:0] state;
reg [n-1:0] next_state;

always @(posedge clk or posedge rst) begin
  if (rst) begin
    state <= 0;
  end else begin
    state <= next_state;
  end
end

always @(*) begin
  case (state)
    4'b0000: next_state = 4'b0001;
    4'b0001: next_state = 4'b0011;
    4'b0011: next_state = 4'b0111;
    4'b0111: next_state = 4'b1111;
    4'b1111: next_state = 4'b1110;
    4'b1110: next_state = 4'b1100;
    4'b1100: next_state = 4'b1000;
    4'b1000: next_state = 4'b0000;
    default: next_state = 4'b0000;
  endcase
end

assign out = state;

endmodule