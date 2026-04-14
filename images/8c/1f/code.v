module top_module( din, dout,p );input [1:0] din;
output [1:0] dout;
input p;

reg [1:0] dout;

parameter MM = 2'b00, M = 2'b01,P = 2'b10,PP = 2'b11;

always @ (*)
begin
  case(din)
    MM: if (p) dout = M; else dout = MM;
    M: if (p) dout = P; else dout = MM;
    P: if (p) dout = PP; else dout = M;
    PP: if (p) dout = PP; else dout = P;
  endcase
end

endmodule