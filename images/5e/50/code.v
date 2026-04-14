module top_module(PCValue, InstructionRead,Clk, ReadDataPCValue, ReadDataInstructionRead, flushcontrol, stallcontrol);input [31:0] PCValue, InstructionRead;
	input Clk;
	input stallcontrol, flushcontrol;
	output reg [31:0] ReadDataPCValue, ReadDataInstructionRead;
	
	    always @(posedge Clk) begin
        
        if(flushcontrol == 1'b1)begin
            ReadDataPCValue <= 0; 
            ReadDataInstructionRead <= 0; 
        end 
        else if(stallcontrol == 1'b1) begin
            ReadDataPCValue <= ReadDataPCValue; 
            ReadDataInstructionRead <= ReadDataInstructionRead; 
        end
        else begin 
            ReadDataPCValue <= PCValue;
            ReadDataInstructionRead <= InstructionRead;
        end
   
    end
 

endmodule