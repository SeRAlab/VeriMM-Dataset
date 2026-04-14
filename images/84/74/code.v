module top_module(
  input [7:0] D0,
  input [7:0] D1,
  input [7:0] D2,
  input [7:0] D3,
  input [1:0] SEL,
  output [7:0] Y
);assign Y = (SEL == 2'b00) ? D0 :
             (SEL == 2'b01) ? D1 :
             (SEL == 2'b10) ? D2 :
             (SEL == 2'b11) ? D3 :
             8'h00;

endmodule