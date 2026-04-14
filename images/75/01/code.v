module top_module(output reg       a,
   output reg	    b,
   input wire [1:0] sel,
   input wire	    d
   );always @* begin
      b = d;
      case (sel)
	0:
	  begin
	     a = 0;
	     b = 1;
	  end
	1:
	  begin
	     a = 1;
	     b = 0;
	  end
	default:
	  begin
	     a = d;
	  end
      endcase 
   end 

endmodule