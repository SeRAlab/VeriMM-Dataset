module pipelined_adder (
    input clk,
    input rst,
    input [7:0] A,
    input [7:0] B,
    input stall,
    output reg [7:0] result
);
    // Pipeline registers
    reg [7:0] A_reg, B_reg;
    reg [7:0] ALU_out;
    
    // Stage 1: IF
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A_reg <= 8'b0;
            B_reg <= 8'b0;
        end else if (!stall) begin
            A_reg <= A;
            B_reg <= B;
        end
    end

    // Stage 2: ID
    // No operation needed, just pass A_reg and B_reg to EX stage

    // Stage 3: EX
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ALU_out <= 8'b0;
        end else if (!stall) begin
            ALU_out <= A_reg + B_reg; // Perform addition
        end
    end

    // Stage 4: MEM
    // No memory operation for this simple case, just pass ALU_out

    // Stage 5: WB
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result <= 8'b0;
        end else if (!stall) begin
            result <= ALU_out; // Write back the result
        end
    end
endmodule