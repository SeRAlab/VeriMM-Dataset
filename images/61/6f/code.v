module top_module(
  input clk, // Add clock input
  input [n-1:0] in,
  output reg [m-1:0] out
);parameter n = 4; // number of input signals
parameter m = 2; // number of output signals
parameter s = 8; // number of states in the FSM
parameter c = 3; // number of bits required to represent the state codes

reg [c-1:0] current_state, next_state;

// State encoding
localparam [c-1:0] S0 = 3'b000,
                   S1 = 3'b001,
                   S2 = 3'b011,
                   S3 = 3'b010,
                   S4 = 3'b110,
                   S5 = 3'b111,
                   S6 = 3'b101,
                   S7 = 3'b100;

// State transition rules
always @(*) begin
  case (current_state)
    S0: next_state = in[0] ? S1 : S0;
    S1: next_state = in[1] ? S2 : S0;
    S2: next_state = in[2] ? S3 : S1;
    S3: next_state = in[3] ? S4 : S2;
    S4: next_state = in[0] ? S5 : S3;
    S5: next_state = in[1] ? S6 : S4;
    S6: next_state = in[2] ? S7 : S5;
    S7: next_state = in[3] ? S0 : S6;
    default: next_state = S0;
  endcase
end

// Output rules
always @(*) begin
  case (current_state)
    S0: out = 2'b00;
    S1: out = 2'b01;
    S2: out = 2'b10;
    S3: out = 2'b11;
    S4: out = 2'b00;
    S5: out = 2'b01;
    S6: out = 2'b10;
    S7: out = 2'b11;
    default: out = 2'b00;
  endcase
end

// State register
always @(posedge clk) begin
  current_state <= next_state;
end

endmodule