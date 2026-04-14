module top_module(
  input clk,            // Added clk as input
  input [n-1:0] in,
  output reg [m-1:0] out // Changed to reg since it is driven in an always block
);parameter n = 4; // number of input signals
parameter m = 2; // number of output signals
parameter s = 8; // number of states in the FSM

function integer log2; // Define a function to compute log2
  input integer value;
  begin
    log2 = 0;
    while (2**log2 < value) begin
      log2 = log2 + 1;
    end
  end
endfunction

reg [log2(s)-1:0] state; // register to hold current state
reg [log2(s)-1:0] next_state; // register to hold next state

// state transition table
always @ (state or in) begin
  case (state)
    3'b000: next_state = (in[0]) ? 3'b001 : 3'b010;
    3'b001: next_state = (in[1]) ? 3'b011 : 3'b100;
    3'b010: next_state = (in[2]) ? 3'b011 : 3'b100;
    3'b011: next_state = (in[3]) ? 3'b111 : 3'b100;
    3'b100: next_state = (in[0]) ? 3'b101 : 3'b110;
    3'b101: next_state = (in[1]) ? 3'b011 : 3'b110;
    3'b110: next_state = (in[2]) ? 3'b011 : 3'b100;
    3'b111: next_state = (in[3]) ? 3'b111 : 3'b100;
    default: next_state = 3'b000; // Added default case
  endcase
end

// output signals
always @ (state) begin
  case (state)
    3'b000: out = {1'b0, 1'b0};
    3'b001: out = {1'b0, 1'b1};
    3'b010: out = {1'b1, 1'b0};
    3'b011: out = {1'b1, 1'b1};
    3'b100: out = {1'b1, 1'b0};
    3'b101: out = {1'b1, 1'b1};
    3'b110: out = {1'b0, 1'b1};
    3'b111: out = {1'b1, 1'b1};
    default: out = {1'b0, 1'b0}; // Added default case
  endcase
end

// state register
always @ (posedge clk) begin
  state <= next_state;
end

endmodule