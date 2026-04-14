module top_module(CLK, RST, stall, flush, IF_instruction, IF_PC, ID_instruction, ID_PC);input CLK,RST,flush,stall;
input [31:0]IF_PC,IF_instruction;
output reg [31:0] ID_PC,ID_instruction;

always@(posedge RST or posedge CLK) begin
    if(RST) begin
        ID_PC<=32'h00000000; 
        ID_instruction<=32'b0;  
    end
    else begin
        ID_PC<= (stall|flush) ? ID_PC:IF_PC;
        ID_instruction<= (flush) ? 32'b0: 
                                     (stall) ? ID_instruction :
                                     IF_instruction;
    end
end
endmodule