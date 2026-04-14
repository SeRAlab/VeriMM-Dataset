module top_module(
	input 	clk,		   			
	input	clk28m,					
	input 	[8:1] reg_address_in,	
	input 	[11:0] data_in,			
	input	[5:0] bpldata,			
	output	reg [11:0] rgb			
);parameter COLORBASE = 9'h180;  		


reg 	[11:0] colortable [15:0];	
wire	[11:0] selcolor;			





always @(posedge clk)
	if (reg_address_in[8:5]==COLORBASE[8:5])
		colortable[reg_address_in[4:1]] <= data_in[11:0];


assign selcolor = colortable[bpldata[3:0]];   




always @(posedge clk28m)
begin
	case (bpldata[5:4])
		2'b00:
			rgb <= selcolor;
		2'b01:
			rgb  <= {rgb[11:4],bpldata[3:0]};	
		2'b10:
			rgb <= {bpldata[3:0],rgb[7:0]};
		2'b11:
			rgb <= {rgb[11:8],bpldata[3:0],rgb[3:0]};
	endcase
end

endmodule