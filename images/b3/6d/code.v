module top_module(dataa, datab, cin, add_sub, bwd, result, cout, overflow);input	[31:0]	dataa,datab;
	input			cin;
	input			add_sub;	
	input	 [1:0]	bwd;
	
	output	[31:0]	result;
	output			cout,overflow;
	
	reg		 [2:0]	seldat;
	reg				overflow;

	wire	[32:0]	summe;
	
	assign summe = {1'b0,dataa} + {1'b0,(add_sub ? datab : ~datab)} + {32'd0,cin};
	
	always @(bwd or dataa or datab or summe)
		case (bwd)
		  2'b00   : seldat = {summe[7], dataa[7], datab[7]};
		  2'b01   : seldat = {summe[15],dataa[15],datab[15]};
		  default : seldat = {summe[31],dataa[31],datab[31]};
		endcase
		  
	always @(seldat or add_sub)
		case (seldat[1:0])
		  2'b00 : overflow = add_sub ?  seldat[2] : 1'b0;
		  2'b01 : overflow = add_sub ? 1'b0 :  seldat[2];
		  2'b10 : overflow = add_sub ? 1'b0 : ~seldat[2];
		  2'b11 : overflow = add_sub ? ~seldat[2] : 1'b0;
		endcase

	assign cout = add_sub ? summe[32] : ~summe[32];
	assign result = summe[31:0];
	
endmodule