module instruction_pipeline (
    input clk,
    input reset,
    input [31:0] instruction_in,
    output reg [31:0] fetch_out,
    output reg [31:0] decode_out,
    output reg [31:0] execute_out,
    output reg [31:0] memory_out,
    output reg [31:0] write_back_out
);
    reg [31:0] fetch_reg, decode_reg, execute_reg, memory_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            fetch_reg <= 32'b0;
            decode_reg <= 32'b0;
            execute_reg <= 32'b0;
            memory_reg <= 32'b0;
            fetch_out <= 32'b0;
            decode_out <= 32'b0;
            execute_out <= 32'b0;
            memory_out <= 32'b0;
            write_back_out <= 32'b0;
        end else begin
            // Pipeline stages
            fetch_reg <= instruction_in; // Fetch stage
            fetch_out <= fetch_reg;

            decode_reg <= fetch_reg; // Decode stage
            decode_out <= decode_reg;

            execute_reg <= decode_reg; // Execute stage
            execute_out <= execute_reg;

            memory_reg <= execute_reg; // Memory stage
            memory_out <= memory_reg;

            write_back_out <= memory_reg; // Write-Back stage
        end
    end
endmodule