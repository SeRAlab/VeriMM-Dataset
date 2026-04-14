module top_module(
  input clk, rst,
  input [p-1:0] code,
  output reg [n-1:0] out // Change from wire to reg
);parameter n = 4; // number of states
parameter p = 2; // number of inputs to the state machine

reg [n-1:0] state;
reg [n-1:0] next_state;

always @ (posedge clk) begin
  if (rst) begin
    state <= 1'b1;
  end else begin
    state <= next_state;
  end
end

always @ (*) begin
  case (state)
    1'b1: begin
      next_state = code[0] ? 2'b10 : 2'b01;
      out = 2'b10;
    end
    2'b01: begin
      next_state = code[0] ? 2'b11 : 2'b10;
      out = 2'b01;
    end
    2'b10: begin
      next_state = code[0] ? 2'b01 : 2'b11;
      out = 2'b10;
    end
    2'b11: begin
      next_state = code[0] ? 2'b10 : 2'b01;
      out = 2'b01;
    end
    default: begin
      next_state = 1'b0; // Default next state to avoid latches
      out = 0;           // Default output value
    end
  endcase
end

endmodule