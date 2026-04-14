module top_module(
  input clk,
  input [n-1:0] in,
  output reg [m-1:0] out // Changed to reg type
);parameter n = 4; // number of input signals
parameter m = 2; // number of output signals
parameter s = 4; // number of states

reg [s-1:0] state;
reg [m-1:0] next_out;
reg [s-1:0] next_state;

always @ (in, state) begin
  case (state)
    0: begin // State 0
      next_out = {in[0], in[1]};
      next_state = in[2] ? 1 : 0;
    end
    1: begin // State 1
      next_out = {in[2], in[3]};
      next_state = in[0] ? 2 : 0;
    end
    2: begin // State 2
      next_out = {in[1], in[3]};
      next_state = in[2] ? 3 : 0;
    end
    3: begin // State 3
      next_out = {in[0], in[2]};
      next_state = in[3] ? 1 : 0;
    end
    default: begin // Added default case to prevent latches
      next_out = {2{1'b0}};
      next_state = 0;
    end
  endcase
end

always @ (posedge clk) begin
  state <= next_state;
  out <= next_out; // out is now a reg, so this is valid
end

endmodule