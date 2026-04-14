module top_module(select,data_i00,data_i01,data_i02,data_i03,data_i04,data_i05,data_i06,data_i07,data_o);parameter Size = 8;

   input wire [('d3) - ('b1):0] select;
   input wire [(Size) - ('b1):0] data_i00;
   input wire [(Size) - ('b1):0] data_i01;
   input wire [(Size) - ('b1):0] data_i02;
   input wire [(Size) - ('b1):0] data_i03;
   input wire [(Size) - ('b1):0] data_i04;
   input wire [(Size) - ('b1):0] data_i05;
   input wire [(Size) - ('b1):0] data_i06;
   input wire [(Size) - ('b1):0] data_i07;

   output reg [(Size) - ('b1):0] data_o;

   always @ (select or 
	     data_i00 or data_i01 or data_i02 or data_i03 or data_i04 or data_i05 or data_i06 or data_i07) begin
      case (select)
	'b000: data_o = data_i00;
	'b001: data_o = data_i01;
	'b010: data_o = data_i02;
	'b011: data_o = data_i03;
	'b100: data_o = data_i04;
	'b101: data_o = data_i05;
	'b110: data_o = data_i06;
	'b111: data_o = data_i07;
      endcase
   end
endmodule