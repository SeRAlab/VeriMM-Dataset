module top_module(
		input[31:0] RDAT,
		input[4:0] Header_count,
		input[8:0] wraddr,
		input[31:0] dataout,
		
		output condition_SP,
		output condition_EH,
		output condition_PL,
		output condition_ST,
		output[1:0] condition_length,
		output[1:0] condition_length2
		);parameter	Height	= 12'd1024;
parameter	Width	= 12'd1024;			
parameter	length = 12'd1040;

parameter	MAC_addressPC = 48'h0019E075BFFD;		

assign	condition_SP = (RDAT==MAC_addressPC[47:16]);
assign	condition_EH = (Header_count==5'd10);
assign	condition_PL = (Header_count==5'd12);
assign	condition_length = (dataout[11:0]==12'h034)?2'd1:((dataout[11:0]==length)?2'd2:(dataout[11:0]==12'h018)?2'd3:2'd0);
assign	condition_length2 = (dataout[15:0]==16'h0100)?2'd1:((dataout[15:0]==16'h0300)?2'd2:(dataout[15:0]==16'h0200)?2'd3:2'd0);
assign	condition_ST = (wraddr[8:0]==((length-14)>>2));

endmodule