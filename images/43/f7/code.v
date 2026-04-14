module top_module(in0, in1, ALUop, out, CY, zero);parameter integer n = 12;

  input [n-1:0] in0,in1;
  input [1:0] ALUop;
  output reg [n-1:0] out;
  output reg CY;
  output zero;
  assign zero = ~|{out};

  always@(in0, in1, ALUop) begin
    out <= {n{1'b0}};
    case (ALUop)
        2'b00: out <= in0 & in1;
        2'b01: {CY, out} <= in0 + in1;
    endcase
  end
endmodule