module top_module(output reg [1:0] foo,
   input wire [1:0] addr,
   input wire	    in0, in1,
   input wire	    en0, en1
   );localparam foo_default = 2'b00;
   always @*
     begin
	foo = foo_default;
	case (addr)
	  0: if (en0) foo[0] = in0;
	  1: if (en1) foo[1] = in1;
	  2: foo = {in1, in0};
	  default: foo = 0;
	endcase
     end

endmodule