module top_module(
   input 	 x,
   input   [7:0] in_cell,
   output  [7:0] out_cell
   );function [6:0] LOOKUP;
      input 	   lookup_type;
      input  [6:0] input_cell;
      input 	   obstacle;

      begin
	 if ( obstacle )
	    LOOKUP = { input_cell[6], input_cell[2:0], input_cell[5:3] };
	 else if ( lookup_type == 1 ) begin
	    case ( input_cell )
	      7'd18:
		LOOKUP = 7'd36;
	      7'd9:
		LOOKUP = 7'd18;
	      7'd36:
		LOOKUP = 7'd9;
	      7'd96:
		LOOKUP = 7'd17;
	      7'd80:
		LOOKUP = 7'd40;
	      7'd72:
		LOOKUP = 7'd20;
	      7'd68:
		LOOKUP = 7'd10;
	      7'd66:
		LOOKUP = 7'd5;
	      7'd65:
		LOOKUP = 7'd34;
	      7'd20:
		LOOKUP = 7'd72;
	      7'd40:
		LOOKUP = 7'd80;
	      7'd17:
		LOOKUP = 7'd96;
	      7'd34:
		LOOKUP = 7'd65;
	      7'd5:
		LOOKUP = 7'd66;
	      7'd10:
		LOOKUP = 7'd68;
	      7'd21:
		LOOKUP = 7'd42;
	      7'd42:
		LOOKUP = 7'd21;
	      7'd100:
		LOOKUP = 7'd73;
	      7'd82:
		LOOKUP = 7'd100;
	      7'd73:
		LOOKUP = 7'd82;
	      7'd85:
		LOOKUP = 7'd106;
	      7'd106:
		LOOKUP = 7'd85;
	      default:
		LOOKUP = 7'd0;
	    endcase 
	 end
	 else begin
	    case ( input_cell )
	      7'd18:
		LOOKUP = 7'd9;
	      7'd9:
		LOOKUP = 7'd36;
	      7'd36:
		LOOKUP = 7'd18;
	      7'd96:
		LOOKUP = 7'd17;
	      7'd80:
		LOOKUP = 7'd40;
	      7'd72:
		LOOKUP = 7'd20;
	      7'd68:
		LOOKUP = 7'd10;
	      7'd66:
		LOOKUP = 7'd5;
	      7'd65:
		LOOKUP = 7'd34;
	      7'd20:
		LOOKUP = 7'd72;
	      7'd40:
		LOOKUP = 7'd80;
	      7'd17:
		LOOKUP = 7'd96;
	      7'd34:
		LOOKUP = 7'd65;
	      7'd5:
		LOOKUP = 7'd66;
	      7'd10:
		LOOKUP = 7'd68;
	      7'd21:
		LOOKUP = 7'd42;
	      7'd42:
		LOOKUP = 7'd21;
	      7'd100:
		LOOKUP = 7'd82;
	      7'd82:
		LOOKUP = 7'd73;
	      7'd73:
		LOOKUP = 7'd100;
	      7'd85:
		LOOKUP = 7'd106;
	      7'd106:
		LOOKUP = 7'd85;
	      default:
		LOOKUP = 7'd0;
	    endcase
	 end
      end
   endfunction

   assign out_cell = { in_cell[7], LOOKUP( x, in_cell[6:0], in_cell[7]) };

endmodule