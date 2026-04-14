module top_module(select,data_i00,data_i01,data_i02,data_i03,data_i04,data_i05,data_i06,data_i07,data_i08,data_i09,data_i10,data_i11,data_i12,data_i13,data_i14,data_i15,data_o);parameter Size = 8;

   input wire [('d4) - ('b1):0] select;
   input wire [(Size) - ('b1):0] data_i00;
   input wire [(Size) - ('b1):0] data_i01;
   input wire [(Size) - ('b1):0] data_i02;
   input wire [(Size) - ('b1):0] data_i03;
   input wire [(Size) - ('b1):0] data_i04;
   input wire [(Size) - ('b1):0] data_i05;
   input wire [(Size) - ('b1):0] data_i06;
   input wire [(Size) - ('b1):0] data_i07;
   input wire [(Size) - ('b1):0] data_i08;
   input wire [(Size) - ('b1):0] data_i09;
   input wire [(Size) - ('b1):0] data_i10;
   input wire [(Size) - ('b1):0] data_i11;
   input wire [(Size) - ('b1):0] data_i12;
   input wire [(Size) - ('b1):0] data_i13;
   input wire [(Size) - ('b1):0] data_i14;
   input wire [(Size) - ('b1):0] data_i15;

   output reg [(Size) - ('b1):0] data_o;

   always @ (select or 
	     data_i00 or data_i01 or data_i02 or data_i03 or data_i04 or data_i05 or data_i06 or data_i07 or
	     data_i08 or data_i09 or data_i10 or data_i11 or data_i12 or data_i13 or data_i14 or data_i15) begin
      case (select)
	'b0000: data_o = data_i00;
	'b0001: data_o = data_i01;
	'b0010: data_o = data_i02;
	'b0011: data_o = data_i03;
	'b0100: data_o = data_i04;
	'b0101: data_o = data_i05;
	'b0110: data_o = data_i06;
	'b0111: data_o = data_i07;
	'b1000: data_o = data_i08;
	'b1001: data_o = data_i09;
	'b1010: data_o = data_i10;
	'b1011: data_o = data_i11;
	'b1100: data_o = data_i12;
	'b1101: data_o = data_i13;
	'b1110: data_o = data_i14;
	'b1111: data_o = data_i15;
      endcase
   end
endmodule