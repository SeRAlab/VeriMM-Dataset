module top_module(
  input clk,
  input rst,
  input [n-1:0] in,
  output reg [m-1:0] out // Changed wire to reg
);parameter n = 4; // number of input signals
parameter m = 2; // number of output signals
parameter ns = 4; // number of states in the original FSM
parameter ne = 8; // number of states in the converted FSM

reg [ns-1:0] state_orig; // current state of the original FSM
reg [ne-1:0] state_conv; // current state of the converted FSM
reg [ne-1:0] next_state; // next state of the converted FSM

// State encoding converter
always @(*) begin
  case(state_orig)
    0: state_conv = 0;
    1: state_conv = 1;
    2: state_conv = 3;
    3: state_conv = 2;
    default: state_conv = 0;
  endcase
end

// State transition table
always @(posedge clk, posedge rst) begin
  if (rst) begin
    state_orig <= 0;
    next_state <= 0;
  end else begin
    state_orig <= next_state[1:0];
    case(state_conv)
      0: next_state <= {in[0], in[1]};
      1: next_state <= {in[2], in[3]};
      2: next_state <= {in[1], in[2]};
      3: next_state <= {in[0], in[3]};
      4: next_state <= {in[0], in[1]};
      5: next_state <= {in[2], in[3]};
      6: next_state <= {in[1], in[2]};
      7: next_state <= {in[0], in[3]};
      default: next_state <= 0;
    endcase
  end
end

// Output table
always @(*) begin
  case(state_conv)
    0: out <= {1'b0, 1'b0};
    1: out <= {1'b0, 1'b1};
    2: out <= {1'b1, 1'b0};
    3: out <= {1'b1, 1'b1};
    4: out <= {1'b0, 1'b0};
    5: out <= {1'b0, 1'b1};
    6: out <= {1'b1, 1'b0};
    7: out <= {1'b1, 1'b1};
    default: out <= {1'b0, 1'b0};
  endcase
end

endmodule