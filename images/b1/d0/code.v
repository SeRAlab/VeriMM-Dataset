module top_module(Flush, Stall, PCValueIn, InstructionIn, Clk, PCValueOut, InstructionOut);output reg [31:0] PCValueOut;
    output reg [31:0] InstructionOut;

    input [31:0] PCValueIn;
    input [31:0] InstructionIn;
    input Flush, Stall, Clk; 
        
    always @ (posedge Clk)
        begin
        if (Flush == 1) begin
            PCValueOut <= 0; 
            InstructionOut <= 0; 
        end else if (Stall != 1) begin
            PCValueOut <= PCValueIn; 
            InstructionOut <= InstructionIn; 
        end
    end  

endmodule