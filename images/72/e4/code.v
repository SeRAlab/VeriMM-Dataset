module top_module(input clk,rst,output reg RdOrR2,AluOrMem,RFWE,MWE,output reg[1:0] stackContrl,pcContrl,input Zero,Cout,input[5:0] cntlInstruc);always@(rst,Zero,Cout,cntlInstruc)
	begin
		if((cntlInstruc[5] == 1'b0) || (cntlInstruc[5:3] == 3'b110))  
		begin
			RdOrR2=1'b0;
			AluOrMem=1'b1;
			RFWE=1'b1;
			MWE=1'b0;
			stackContrl=2'b00;
			pcContrl=2'b00;
		end
		else if(cntlInstruc[5:1] == 5'b10000) 
		begin
			RdOrR2=1'b0;
			AluOrMem=1'b0;
			RFWE=1'b1;
			MWE=1'b0;
			stackContrl=2'b00;
			pcContrl=2'b00;
		end
		else if(cntlInstruc[5:1] == 5'b10001) 
		begin
			RdOrR2=1'b1;
			AluOrMem=1'b1;
			RFWE=1'b0;
			MWE=1'b1;
			stackContrl=2'b00;
			pcContrl=2'b00;
		end
		else if(cntlInstruc[5:3] == 3'b101) 
		begin
			RdOrR2=1'b0;
			AluOrMem=1'b1;
			RFWE=1'b0;
			MWE=1'b0;
			stackContrl=2'b00;
			case(cntlInstruc[2:1])
				2'b00: pcContrl= Zero ? 2'b01 : 2'b00;
				2'b01: pcContrl= (~Zero) ? 2'b01 : 2'b00;
				2'b10: pcContrl= Cout ? 2'b01 : 2'b00;
				2'b11: pcContrl= (~Cout) ? 2'b01 : 2'b00;
			endcase
		end
		else if(cntlInstruc[5:1] == 5'b11100) 
		begin
			RdOrR2=1'b0;
			AluOrMem=1'b1;
			RFWE=1'b0;
			MWE=1'b0;
			stackContrl=2'b00;
			pcContrl=2'b11;
		end
		else if(cntlInstruc[5:1] == 5'b11101) 
		begin
			RdOrR2=1'b0;
			AluOrMem=1'b1;
			RFWE=1'b0;
			MWE=1'b0;
			stackContrl=2'b01;
			pcContrl=2'b11;
		end
		else if(cntlInstruc[5:0] == 6'b111100) 
		begin
			RdOrR2=1'b0;
			AluOrMem=1'b1;
			RFWE=1'b0;
			MWE=1'b0;
			stackContrl=2'b10;
			pcContrl=2'b10;
		end
		else
		begin
			RdOrR2=1'b0;
			AluOrMem=1'b0;
			RFWE=1'b0;
			MWE=1'b0;
			stackContrl=2'b00;
			pcContrl=2'b00;
		end
	end
endmodule