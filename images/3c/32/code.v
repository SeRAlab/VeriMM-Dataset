module pipelined_processor (  
    input clk,  
    input reset,  
    input [7:0] instruction,  
    output reg [7:0] result  
);  
    reg [7:0] IF_ID_inst, ID_EX_inst, EX_MEM_inst, MEM_WB_inst;  
    reg [7:0] EX_result, MEM_result;  
    reg [3:0] ID_regA, ID_regB;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            IF_ID_inst <= 0;  
            ID_EX_inst <= 0;  
            EX_MEM_inst <= 0;  
            MEM_WB_inst <= 0;  
            result <= 0;  
        end else begin  
            // Fetch stage  
            IF_ID_inst <= instruction;  

            // Decode stage  
            ID_EX_inst <= IF_ID_inst;  
            ID_regA <= IF_ID_inst[3:0];  
            ID_regB <= IF_ID_inst[7:4];  

            // Execute stage  
            case (ID_EX_inst[7:4])  
                4'b0001: EX_result <= ID_regA + ID_regB; // ADD  
                4'b0010: EX_result <= ID_regA - ID_regB; // SUB  
                default: EX_result <= 0;  
            endcase  
            EX_MEM_inst <= EX_result;  

            // Memory Access stage  
            MEM_result <= EX_MEM_inst;  
            MEM_WB_inst <= MEM_result;  

            // Write Back stage  
            result <= MEM_WB_inst;  
        end  
    end  
endmodule