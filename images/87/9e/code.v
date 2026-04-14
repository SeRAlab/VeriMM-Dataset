module top_module(
	 output [127:0] shftOut, 
	 input [127:0] shftIn,	
	 input inv					
    );assign shftOut[127:120] = shftIn[127:120];
	 assign shftOut[95:88] = shftIn[95:88];
	 assign shftOut[63:56] = shftIn[63:56];
	 assign shftOut[31:24] = shftIn[31:24];
	 
	 
	 assign shftOut[119:112] = (inv)?(shftIn[23:16]):(shftIn[87:80]);
	 assign shftOut[87:80] = (inv)?(shftIn[119:112]):(shftIn[55:48]);
	 assign shftOut[55:48] = (inv)?(shftIn[87:80]):(shftIn[23:16]);
	 assign shftOut[23:16] = (inv)?(shftIn[55:48]):(shftIn[119:112]);
	 
	 
	 assign shftOut[111:104] = shftIn[47:40];
	 assign shftOut[79:72] = shftIn[15:8];
	 assign shftOut[47:40] = shftIn[111:104];
	 assign shftOut[15:8] = shftIn[79:72];
	 
	 
	 assign shftOut[103:96] = (inv)?(shftIn[71:64]):(shftIn[7:0]);
	 assign shftOut[71:64] = (inv)?(shftIn[39:32]):(shftIn[103:96]);
	 assign shftOut[39:32] = (inv)?(shftIn[7:0]):(shftIn[71:64]);
	 assign shftOut[7:0] = (inv)?(shftIn[103:96]):(shftIn[39:32]);
	 
endmodule