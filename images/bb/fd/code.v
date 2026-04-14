module top_module(
  input [n-1:0] in,
  output reg [m-1:0] out
);parameter n = 4; // number of input signals
parameter m = 2; // number of output signals
parameter s = 8; // number of states

reg [2:0] state; // 3-bit state encoding

// State transition table
always @ (in, state)
begin
  case (state)
    3'b000: if (in == 4'b0000) state <= 3'b000; else state <= 3'b001;
    3'b001: if (in == 4'b0000) state <= 3'b010; else state <= 3'b011;
    3'b010: if (in == 4'b0000) state <= 3'b100; else state <= 3'b101;
    3'b011: if (in == 4'b0000) state <= 3'b110; else state <= 3'b111;
    3'b100: if (in == 4'b0000) state <= 3'b000; else state <= 3'b001;
    3'b101: if (in == 4'b0000) state <= 3'b010; else state <= 3'b011;
    3'b110: if (in == 4'b0000) state <= 3'b100; else state <= 3'b101;
    3'b111: if (in == 4'b0000) state <= 3'b110; else state <= 3'b111;
  endcase
end

// Output function table
always @ (state)
begin
  case (state)
    3'b000: out <= 2'b00;
    3'b001: out <= 2'b01;
    3'b010: out <= 2'b10;
    3'b011: out <= 2'b11;
    3'b100: out <= 2'b00;
    3'b101: out <= 2'b01;
    3'b110: out <= 2'b10;
    3'b111: out <= 2'b11;
  endcase
end

endmodule