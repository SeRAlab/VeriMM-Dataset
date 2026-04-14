module top_module( J ,CLK ,PE ,UpDown_bar ,CE ,Q ,CarryOut );output [3:0] Q ;
reg [3:0] Q, Qtmp ;
output CarryOut ;
wire CarryOut ;

input [3:0] J ;
wire [3:0] J ;
input CLK ;
wire CLK ;
input PE ;
wire PE ;
input UpDown_bar ;
wire UpDown_bar ;
input CE ;
wire CE ;


assign Q = Qtmp;
assign #120 CarryOut = ~( & Qtmp | ~UpDown_bar & ~CE & (~|Qtmp)) ;
always @ (posedge CLK or posedge PE) begin
	if (PE)
		Qtmp <= #285 J;
	else if (!CE)
		begin 
			if(UpDown_bar)
		#200 Qtmp <= Qtmp + 1;
		else 
		#200 Qtmp <= Qtmp - 1;
		end
			end

specify 
$setup (UpDown_bar, posedge CLK, 180);
endspecify
endmodule