module pipelined_processor (
    input clk,
    input reset,
    input [31:0] instruction,
    output reg [31:0] result
);
    reg [31:0] IF_ID_inst, ID_EX_inst, EX_MEM_inst, MEM_WB_inst;
    reg [31:0] ID_EX_result, EX_MEM_result, MEM_WB_result;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            IF_ID_inst <= 0;
            ID_EX_inst <= 0;
            EX_MEM_inst <= 0;
            MEM_WB_inst <= 0;
            result <= 0;
        end else begin
            // Fetch Stage
            IF_ID_inst <= instruction;

            // Decode Stage
            ID_EX_inst <= IF_ID_inst;

            // Execute Stage
            EX_MEM_inst <= ID_EX_inst;
            ID_EX_result <= EX_MEM_inst + 1; // Example operation

            // Memory Access Stage
            MEM_WB_inst <= EX_MEM_inst;
            EX_MEM_result <= ID_EX_result;

            // Write Back Stage
            result <= EX_MEM_result; // Final output
        end
    end
endmodule