module top_module(Data, Address);parameter T_rd = 20;
   parameter MemSize = 40;
   
   output [31:0] Data;
   input [63:0]  Address;
   reg [31:0] 	 Data;
   
   
   
   always @ (Address) begin
      case(Address)

	
	

	63'h000: Data = 32'hF84003E9;
	63'h004: Data = 32'hF84083EA;
	63'h008: Data = 32'hF84103EB;
	63'h00c: Data = 32'hF84183EC;
	63'h010: Data = 32'hF84203ED;
	63'h014: Data = 32'hAA0B014A;
	63'h018: Data = 32'h8A0A018C;
	63'h01c: Data = 32'hB400008C;
	63'h020: Data = 32'h8B0901AD;
	63'h024: Data = 32'hCB09018C;
	63'h028: Data = 32'h17FFFFFD;
	63'h02c: Data = 32'hF80203ED;
	63'h030: Data = 32'hF84203ED;  

	
	

	63'h034:Data = 32'hD2E24689;
	63'h038:Data = 32'hD2CACF0A;
	63'h03c:Data = 32'hD2B3578B;
	63'h040:Data = 32'hD29BDE0C;
	63'h044:Data = 32'hAA0A0129;
	63'h048:Data = 32'hAA0B0129;
	63'h04c:Data = 32'hAA0C0129;
	63'h050:Data = 32'hF80283E9;
	63'h054:Data = 32'hF84283E9;
	
			
	default: Data = 32'hXXXXXXXX;
      endcase
   end
endmodule