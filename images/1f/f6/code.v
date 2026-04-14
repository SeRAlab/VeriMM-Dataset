module instruction_pipeline (
    input wire clk,
    input wire rst,
    input wire [31:0] instruction_in,
    output reg [31:0] instruction_out,
    output reg [31:0] result_out
);
    reg [31:0] IF_ID_instruction;
    reg [31:0] ID_EX_result;
    reg [31:0] EX_MEM_result;
    
    // Fetch stage
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            IF_ID_instruction <= 32'b0;
        end else begin
            IF_ID_instruction <= instruction_in;
        end
    end

    // Decode stage
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ID_EX_result <= 32'b0;
        end else begin
            // Simple decode and execute logic (for example purposes)
            ID_EX_result <= IF_ID_instruction + 1; // Assuming a simple ADD operation
        end
    end

    // Execute stage
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            EX_MEM_result <= 32'b0;
        end else begin
            EX_MEM_result <= ID_EX_result; // Forwarding result
        end
    end

    // Memory Access and Write Back stage
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            instruction_out <= 32'b0;
            result_out <= 32'b0;
        end else begin
            instruction_out <= IF_ID_instruction; // Forwarding instruction
            result_out <= EX_MEM_result; // Final result
        end
    end
endmodule