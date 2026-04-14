module pipeline (
    input clk,
    input reset,
    input [31:0] instruction_in,
    output reg [31:0] instruction_out
);

    reg [31:0] IF_ID_instr;
    reg [31:0] ID_EX_instr;
    reg [31:0] EX_MEM_instr;
    reg [31:0] MEM_WB_instr;
    reg stall;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            IF_ID_instr <= 32'b0;
            ID_EX_instr <= 32'b0;
            EX_MEM_instr <= 32'b0;
            MEM_WB_instr <= 32'b0;
            instruction_out <= 32'b0;
            stall <= 1'b0;
        end else begin
            if (!stall) begin
                // Pipeline stages
                IF_ID_instr <= instruction_in;
                ID_EX_instr <= IF_ID_instr;
                EX_MEM_instr <= ID_EX_instr;
                MEM_WB_instr <= EX_MEM_instr;

                // Output the instruction from the Write Back stage
                instruction_out <= MEM_WB_instr;
            end
            // Example of a simple hazard detection (not comprehensive)
            if (ID_EX_instr[31:26] == 6'b000100) // Branch instruction
                stall <= 1'b1; // Stall the pipeline
            else
                stall <= 1'b0; // Continue
        end
    end
endmodule