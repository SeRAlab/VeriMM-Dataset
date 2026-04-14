module pipelined_processor (  
    input clk,  
    input reset,  
    input [31:0] instruction,  
    output reg [31:0] result,  
    output reg ready  
);  

    reg [31:0] IF_ID_instruction;  
    reg [31:0] ID_EX_instruction;  
    reg [31:0] EX_MEM_instruction;  
    reg [31:0] MEM_WB_instruction;  

    reg [31:0] EX_result;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            IF_ID_instruction <= 0;  
            ID_EX_instruction <= 0;  
            EX_MEM_instruction <= 0;  
            MEM_WB_instruction <= 0;  
            result <= 0;  
            ready <= 0;  
        end else begin  
            // Pipeline stages  
            // IF Stage  
            IF_ID_instruction <= instruction;  
            
            // ID Stage  
            ID_EX_instruction <= IF_ID_instruction;  
            
            // EX Stage  
            case (ID_EX_instruction[31:28]) // Assuming first 4 bits are opcode  
                4'b0000: EX_result <= ID_EX_instruction[27:0] + ID_EX_instruction[27:0]; // ADD  
                4'b0001: EX_result <= ID_EX_instruction[27:0] - ID_EX_instruction[27:0]; // SUB  
                4'b0010: EX_result <= ID_EX_instruction[27:0] & ID_EX_instruction[27:0]; // AND  
                4'b0011: EX_result <= ID_EX_instruction[27:0] | ID_EX_instruction[27:0]; // OR  
                4'b0100: EX_result <= ID_EX_instruction[27:0] ^ ID_EX_instruction[27:0]; // XOR  
                default: EX_result <= 0;  
            endcase  
            
            // MEM Stage  
            EX_MEM_instruction <= EX_result;  
            
            // WB Stage  
            MEM_WB_instruction <= EX_MEM_instruction;  
            result <= MEM_WB_instruction;  
            ready <= 1;  
        end  
    end  
endmodule