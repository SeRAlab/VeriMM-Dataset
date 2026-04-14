module top_module(
	input wire[15:0] in,
	output wire[31:0] saida
);reg [31:0] full;

always @ (in)
begin

if(in[15]==0)
  begin
  full = in;
  end
  else
  begin
  full = {16'b1111111111111111, in};
  end

end

assign saida = full;

endmodule