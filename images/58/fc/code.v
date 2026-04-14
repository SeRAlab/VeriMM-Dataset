module top_module(
  input clk, // Added clock input
  input [n-1:0] in,
  output reg [m-1:0] out
);parameter n = 4; // number of input signals
parameter m = 2; // number of output signals
parameter s = 8; // number of states

// State encoding
localparam [2:0] S0 = 3'b000,
                S1 = 3'b001,
                S2 = 3'b010,
                S3 = 3'b011,
                S4 = 3'b100,
                S5 = 3'b101,
                S6 = 3'b110,
                S7 = 3'b111;

reg [2:0] current_state, next_state;

// State transition logic
always @(*) begin
  case (current_state)
    S0: next_state = (in == 4'b0000) ? S1 : S0;
    S1: next_state = (in == 4'b0001) ? S2 : S1;
    S2: next_state = (in == 4'b0010) ? S3 : S2;
    S3: next_state = (in == 4'b0011) ? S4 : S3;
    S4: next_state = (in == 4'b0100) ? S5 : S4;
    S5: next_state = (in == 4'b0101) ? S6 : S5;
    S6: next_state = (in == 4'b0110) ? S7 : S6;
    S7: next_state = (in == 4'b0111) ? S0 : S7;
    default: next_state = S0;
  endcase
end

// Output logic
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