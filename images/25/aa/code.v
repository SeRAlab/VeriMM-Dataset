module pipeline_processor (
    input clk,
    input reset,
    input [3:0] instruction_in,
    output reg [7:0] result_out
);
    reg [3:0] IF_ID_inst;
    reg [3:0] ID_EX_inst;
    reg [3:0] EX_MEM_inst;
    reg [3:0] MEM_WB_inst;
    reg [7:0] EX_result;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            IF_ID_inst <= 4'b0000;
            ID_EX_inst <= 4'b0000;
            EX_MEM_inst <= 4'b0000;
            MEM_WB_inst <= 4'b0000;
            result_out <= 8'b00000000;
        end else begin
            // Pipeline stages
            IF_ID_inst <= instruction_in;  // IF stage
            ID_EX_inst <= IF_ID_inst;       // ID stage
            EX_MEM_inst <= ID_EX_inst;      // EX stage
            
            // Execute stage
            case (ID_EX_inst[3:0])
                4'b0001: EX_result <= EX_MEM_inst + 8'b00000001; // ADD
                4'b0010: EX_result <= EX_MEM_inst - 8'b00000001; // SUB
                4'b0011: EX_result <= EX_MEM_inst & 8'b11111111; // AND
                4'b0100: EX_result <= EX_MEM_inst | 8'b00000000; // OR
                default: EX_result <= EX_MEM_inst;
            endcase
            
            // Memory access stage (not implemented for simplicity)
            MEM_WB_inst <= EX_result;  // MEM stage
            
            // Write back stage
            result_out <= MEM_WB_inst;
        end
    end
endmodule