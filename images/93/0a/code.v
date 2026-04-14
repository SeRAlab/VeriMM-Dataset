module top_module(a, b, fnc,
           res, equ, ult, slt);input [31:0] a;
    input [31:0] b;
    input [2:0] fnc;
    output [31:0] res;
    output equ;
    output ult;
    output slt;

  wire [32:0] a1;
  wire [32:0] b1;
  reg [32:0] res1;

  assign a1 = { 1'b0, a };
  assign b1 = { 1'b0, b };

  always @(*) begin
    case (fnc)
      3'b000:  res1 = a1 + b1;
      3'b001:  res1 = a1 - b1;
      3'b010:  res1 = a1;
      3'b011:  res1 = b1;
      3'b100:  res1 = a1 & b1;
      3'b101:  res1 = a1 | b1;
      3'b110:  res1 = a1 ^ b1;
      3'b111:  res1 = a1 ~^ b1;
      default: res1 = 33'hxxxxxxxx;
    endcase
  end

  assign res = res1[31:0];
  assign equ = ~| res1[31:0];
  assign ult = res1[32];
  assign slt = res1[32] ^ a[31] ^ b[31];

endmodule