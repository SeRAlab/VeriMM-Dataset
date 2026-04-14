module top_module(
  input [n-1:0] in,
  output reg [m-1:0] out // Changed output to reg
);parameter n = 4; // number of input signals
parameter m = 2; // number of output signals
parameter s = 8; // number of states in the original FSM

reg [2:0] state; // original FSM state
reg [2:0] merged_state; // merged FSM state

always @ (in or state) begin
  case (state)
    3'b000: begin // state 0
      if (in[0] && in[1]) merged_state = 3'b001; // merge state 0 and 1
      else if (in[2]) merged_state = 3'b010; // merge state 0 and 2
      else merged_state = 3'b000; // stay in state 0
    end
    3'b001: begin // state 1
      if (in[1]) merged_state = 3'b011; // merge state 1 and 3
      else merged_state = 3'b001; // stay in state 1
    end
    3'b010: begin // state 2
      if (in[0]) merged_state = 3'b011; // merge state 2 and 3
      else merged_state = 3'b010; // stay in state 2
    end
    3'b011: begin // state 3
      if (in[3]) merged_state = 3'b111; // merge state 3, 4, 5, and 6
      else merged_state = 3'b011; // stay in state 3
    end
    3'b100: begin // state 4
      if (in[1]) merged_state = 3'b111; // merge state 3, 4, 5, and 6
      else merged_state = 3'b100; // stay in state 4
    end
    3'b101: begin // state 5
      if (in[0] && in[2]) merged_state = 3'b111; // merge state 3, 4, 5, and 6
      else merged_state = 3'b101; // stay in state 5
    end
    3'b110: begin // state 6
      if (in[0] && in[1]) merged_state = 3'b111; // merge state 3, 4, 5, and 6
      else merged_state = 3'b110; // stay in state 6
    end
    3'b111: begin // state 7
      merged_state = 3'b111; // stay in state 7
    end
  endcase
end

always @ (merged_state) begin
  case (merged_state)
    3'b000: out = {1'b0, 1'b0}; // output 0
    3'b001: out = {1'b0, 1'b1}; // output 1
    3'b010: out = {1'b1, 1'b0}; // output 2
    3'b011: out = {1'b1, 1'b1}; // output 3
    3'b111: out = {1'b0, 1'b0}; // output 4
    default: out = {1'b0, 1'b0}; // default output
  endcase
end

endmodule