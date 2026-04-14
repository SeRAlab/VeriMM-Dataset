module pipeline_processor (
    input clk,
    input reset,
    input [31:0] instruction_in,
    input [31:0] data_in,
    output reg [31:0] result_out,
    output reg [31:0] instruction_out
);

    reg [31:0] IF_ID_instr;
    reg [31:0] ID_EX_instr;
    reg [31:0] EX_MEM_result;
    reg [31:0] MEM_WB_result;

    reg [31:0] register_file [0:31]; // Simple register file

    // Fetch Stage
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            instruction_out <= 32'b0;
        end else begin
            instruction_out <= instruction_in;
            IF_ID_instr <= instruction_out;
        end
    end

    // Decode Stage
    always @(posedge clk) begin
        ID_EX_instr <= IF_ID_instr; // Pass instruction to next stage
    end

    // Execute Stage
    always @(posedge clk) begin
        // Simple execution logic: add operation for example
        EX_MEM_result <= register_file[ID_EX_instr[25:21]] + register_file[ID_EX_instr[20:16]];
    end

    // Memory Access Stage
    always @(posedge clk) begin
        MEM_WB_result <= EX_MEM_result; // Forward result to write back
    end

    // Write Back Stage
    always @(posedge clk) begin
        result_out <= MEM_WB_result; // Write the result back
    end

endmodule