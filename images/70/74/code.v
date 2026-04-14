module top_module(fl_n, fl_mask);input [0:2] fl_n;
   output reg [0:5] fl_mask;
   
   always @(fl_n) begin
      case(fl_n)
	3'b000:
	  fl_mask <= 6'b000000;
	3'b001:
	  fl_mask <= 6'b000001;
	3'b010:
	  fl_mask <= 6'b000010;
	3'b011:
	  fl_mask <= 6'b000100;
	3'b100:
	  fl_mask <= 6'b001000;
	3'b101:
	  fl_mask <= 6'b010000;
	3'b110:
	  fl_mask <= 6'b100000;
	3'b111:
	  fl_mask <= 6'b111111;
      endcase 
   end 
   
endmodule