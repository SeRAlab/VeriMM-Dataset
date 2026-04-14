module top_module(DATA0, CLK, RST, SEL, LDCOMP, LDPRE, DATA1, DATA2);output [7:0] DATA0;
input CLK, RST, SEL, LDCOMP, LDPRE;
input [7:0] DATA1, DATA2;
reg [7:0] DATA0;
reg [7:0] highreg_output, lowreg_output; 

wire compare_output =    DATA0 == lowreg_output;  
wire [7:0]  mux_output =    SEL ? DATA1 : highreg_output;  


always @ (posedge CLK  or posedge RST)
begin
	if (RST) begin
		highreg_output = 0;
		lowreg_output = 0;
	end else begin
		if (LDPRE)
			highreg_output = DATA2;
		if (LDCOMP)
			lowreg_output  = DATA2;
	end
end
		

always @(posedge CLK or posedge RST)
begin
	if (RST)
		DATA0 = 0; 
	else if (compare_output)  
		DATA0 = mux_output;
	else
		DATA0 = DATA0 + 1;
end

endmodule