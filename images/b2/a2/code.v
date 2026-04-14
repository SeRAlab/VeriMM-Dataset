module top_module(
    input B13,
    input B12,
    input B11,
    input CY,
    input [15:0] W0to15,
    output pre_load
    );wire case_jmp; 
	assign case_jmp = !B12 & !B11; 
	wire case_jze;
	assign case_jze = (!B12 & B11) & W0to15[0]; 
	wire case_jne;
	assign case_jne = (B12 & !B11) & W0to15[15]; 
	wire case_ccy;
	assign case_ccy = (B12 & B11) & CY; 
	
	assign pre_load = B13 & (case_jmp | case_jze | case_jne);
	
	 
endmodule