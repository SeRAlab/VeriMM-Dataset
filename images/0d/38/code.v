module instruction_pipeline (
    input clk,
    input rst,
    input [31:0] instruction_in,
    output reg [31:0] instruction_out,
    output reg stall
);
    reg [31:0] IF_ID_inst;
    reg [31:0] ID_EX_inst;
    reg [31:0] EX_MEM_inst;
    reg [31:0] MEM_WB_inst;

    reg [4:0] ID_EX_rd;
    reg [4:0] EX_MEM_rd;
    reg [4:0] MEM_WB_rd;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            IF_ID_inst <= 0;
            ID_EX_inst <= 0;
            EX_MEM_inst <= 0;
            MEM_WB_inst <= 0;
            instruction_out <= 0;
            stall <= 0;
        end else begin
            // Instruction fetch stage
            IF_ID_inst <= instruction_in;

            // Instruction decode stage
            ID_EX_inst <= IF_ID_inst;
            ID_EX_rd <= IF_ID_inst[11:7]; // Example: assuming rd is bits [11:7]

            // Control stall condition (load-use hazard detection)
            if (MEM_WB_rd == ID_EX_rd) begin
                stall <= 1; // Stall the pipeline
            end else begin
                stall <= 0; // No stall
            end

            // Execute stage
            if (!stall) begin
                EX_MEM_inst <= ID_EX_inst;
                EX_MEM_rd <= ID_EX_rd; // Pass the rd forward
            end

            // Memory stage
            MEM_WB_inst <= EX_MEM_inst;

            // Writeback stage
            instruction_out <= MEM_WB_inst;
        end
    end
endmodule