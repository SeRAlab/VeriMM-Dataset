module pipeline_processor(
    input clk,
    input [7:0] operand1,
    input [7:0] operand2,
    output reg [7:0] result
);

    reg [7:0] if_reg, id_reg, ex_reg, mem_reg;

    // Instruction Fetch stage
    always @(posedge clk) begin
        if_reg <= operand1; // assuming operand1 as instruction
    end

    // Instruction Decode stage
    always @(posedge clk) begin
        id_reg <= if_reg; // pass instruction to next stage
    end

    // Execute stage
    always @(posedge clk) begin
        ex_reg <= id_reg + operand2; // simple addition
    end

    // Memory Access stage
    always @(posedge clk) begin
        mem_reg <= ex_reg; // passing to memory stage
    end

    // Write Back stage
    always @(posedge clk) begin
        result <= mem_reg; // output the result
    end

endmodule