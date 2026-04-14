module top_module(data2, extenderOutputA, out, cu_aluScr);input cu_aluScr;
  input [31:0] data2;
  input [31:0] extenderOutputA;

  output reg [31:0] out;

  always @ ( * ) begin
    if(cu_aluScr)
      out = extenderOutputA;
    else
      out = data2;
  end
endmodule