module top_module( key_input, key_code, clk );input [8:0] 	key_input;	
   input 			clk;

   output [4:0] 	key_code; 	

   reg [2:0] 		key_note;
   reg [1:0] 		range;

   always @ (posedge clk) begin
      case (key_input[8:7]) 	
			2'b11: range <= 0;
			2'b01: range <= 1;
			2'b00: range <= 2;
			2'b10: range <= 3;
      endcase

      case (key_input[6:0]) 
			7'b0000001: key_note <= 1;
			7'b0000010: key_note <= 2;
			7'b0000100: key_note <= 3;
			7'b0001000: key_note <= 4;
			7'b0010000: key_note <= 5;
			7'b0100000: key_note <= 6;
			7'b1000000: key_note <= 7;
			default:    key_note <= 0;
      endcase
   end

   assign key_code[4:0] = range * key_note;

endmodule