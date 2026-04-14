module top_module(
  input [n-1:0] in,
  input clk, // Added clk input
  output reg [m-1:0] out // Changed output to reg type
);parameter n = 4; // number of input signals
parameter m = 2; // number of output signals
parameter s = 8; // number of states in original FSM

reg [2:0] state; // current state
reg [2:0] next_state; // next state

// define the states
parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;
parameter S5 = 3'b101;
parameter S6 = 3'b110;
parameter S7 = 3'b111;

// define the outputs
parameter O0 = 2'b00;
parameter O1 = 2'b01;
parameter O2 = 2'b10;
parameter O3 = 2'b11;

// define the transition conditions
always @ (*) begin
  case (state)
    S0: if (in[0] == 1) next_state = S1; else next_state = S0;
    S1: if (in[1] == 1) next_state = S2; else next_state = S1;
    S2: if (in[2] == 1) next_state = S3; else next_state = S2;
    S3: if (in[3] == 1) next_state = S4; else next_state = S3;
    S4: if (in[0] == 1) next_state = S5; else next_state = S4;
    S5: if (in[1] == 1) next_state = S6; else next_state = S5;
    S6: if (in[2] == 1) next_state = S7; else next_state = S6;
    S7: if (in[3] == 1) next_state = S0; else next_state = S7;
    default: next_state = S0; // Added default case for safety
  endcase
end

// define the outputs based on the current state
always @ (*) begin
  case (state)
    S0: out = O0;
    S1: out = O1;
    S2: out = O2;
    S3: out = O3;
    S4: out = O0;
    S5: out = O1;
    S6: out = O2;
    S7: out = O3;
    default: out = O0; // Added default case for safety
  endcase
end

// update the state
always @ (posedge clk) begin
  state <= next_state;
end

endmodule