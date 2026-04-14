module top_module(
  input clk,
  input reset,
  input [2:0] counter,
  output reg [2:0] next_counter
);reg [2:0] state, next_state;

always @ (counter) begin
  case (counter)
    3'h0: next_state = 3'h1;
    3'h1: next_state = 3'h2;
    3'h2: next_state = 3'h3;
    3'h3: next_state = 3'h0;
  endcase
end

always @ (posedge clk) begin
  if (reset) begin
    next_counter <= 3'h0;
    state <= 3'h0;
  end else begin
    next_counter <= next_state;
    state <= next_state;
  end
end

endmodule