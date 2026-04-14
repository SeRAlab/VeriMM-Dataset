module pipelined_processor (
    input clk,
    input rst,
    input [31:0] instruction,
    output reg [31:0] result
);
    reg [31:0] IF_ID_instruction;
    reg [31:0] ID_EX_instruction;
    reg [31:0] EX_MEM_result;
    
    // Stage 1: Instruction Fetch
    always @(posedge clk or posedge rst) begin
        if (rst)
            IF_ID_instruction <= 0;
        else
            IF_ID_instruction <= instruction;
    end

    // Stage 2: Instruction Decode
    always @(posedge clk or posedge rst) begin
        if (rst)
            ID_EX_instruction <= 0;
        else
            ID_EX_instruction <= IF_ID_instruction;
    end

    // Stage 3: Execute
    always @(posedge clk or posedge rst) begin
        if (rst)
            EX_MEM_result <= 0;
        else
            EX_MEM_result <= ID_EX_instruction + 1; // Example operation
    end

    // Stage 4: Memory Access
    // Not Implemented in this example, but can be added

    // Stage 5: Write Back
    always @(posedge clk or posedge rst) begin
        if (rst)
            result <= 0;
        else
            result <= EX_MEM_result;
    end
endmodule