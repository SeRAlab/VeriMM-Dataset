module pipeline_adder (
    input clk,
    input [3:0] operand1,
    input [3:0] operand2,
    input [1:0] operation, // 00: add
    output reg [7:0] result
);
    reg [3:0] IF_operand1, IF_operand2;
    reg [1:0] ID_operation;

    always @(posedge clk) begin
        // Instruction Fetch
        IF_operand1 <= operand1;
        IF_operand2 <= operand2;

        // Instruction Decode
        ID_operation <= operation;

        // Execution
        if (ID_operation == 2'b00) begin // Only add operation
            result <= IF_operand1 + IF_operand2;
        end
    end
endmodule