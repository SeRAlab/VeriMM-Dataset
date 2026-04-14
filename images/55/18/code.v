module top_module(
  input [n-1:0] in,
  output reg [m-1:0] out // Changed to reg type to allow assignment in always blocks
);parameter n = 4; // number of input signals
parameter m = 2; // number of output signals
parameter s = 8; // number of states

reg [2:0] state; // current state
reg [1:0] substate; // current sub-state

// transition functions
always @ (in, state) begin
  case (state)
    3'b000: if (in[0]) substate <= 2'b01; else substate <= 2'b00;
    3'b001: if (in[1]) substate <= 2'b01; else substate <= 2'b00;
    3'b010: if (in[2]) substate <= 2'b01; else substate <= 2'b00;
    3'b011: if (in[3]) substate <= 2'b01; else substate <= 2'b00;
    3'b100: if (in[0] && in[1]) substate <= 2'b01; else substate <= 2'b00;
    3'b101: if (in[2] && in[3]) substate <= 2'b01; else substate <= 2'b00;
    3'b110: if (in[0] || in[1]) substate <= 2'b01; else substate <= 2'b00;
    3'b111: if (in[2] || in[3]) substate <= 2'b01; else substate <= 2'b00;
  endcase
end

// output functions
always @ (in, substate) begin
  case (substate)
    2'b00: out <= {in[0], in[1]};
    2'b01: out <= {in[2], in[3]};
  endcase
end

// next state logic
always @ (substate) begin
  case (substate)
    2'b00: state <= 3'b000;
    2'b01: state <= 3'b001;
  endcase
end

endmodule