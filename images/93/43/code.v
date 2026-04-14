module top_module(wb_sel1, wb_sel, ex_result, ReadData, PC_addr, wb_out,LBI_sel,readData1, immed, BTR_sel);parameter W = 16; 
	
	input           wb_sel1, wb_sel, LBI_sel, BTR_sel;
	input[W-1:0]    ex_result, ReadData, PC_addr, immed, readData1;
	output[W-1:0]   wb_out;
	
	wire[W-1:0]     intermediate;
   
    assign intermediate = wb_sel ? (wb_sel1 ? ReadData : ex_result) : PC_addr;
	assign wb_out = BTR_sel ? {readData1[0], readData1[1], readData1[2], readData1[3], readData1[4], readData1[5], 
	readData1[6], readData1[7], readData1[8], readData1[9], readData1[10], readData1[11], readData1[12], readData1[13], 
	readData1[14], readData1[15]} : LBI_sel ? immed : intermediate;
	
endmodule