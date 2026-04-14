module instruction_pipeline (
    input clk,
    input reset,
    input [4:0] instruction,
    output reg [4:0] pc_out,
    output reg [4:0] decoded_output,
    output reg [4:0] exec_output,
    output reg [4:0] mem_output,
    output reg [4:0] write_back_output
);
    reg [4:0] pc;
    reg [4:0] instruction_reg;
    reg [4:0] decoded_reg;
    reg [4:0] exec_reg;
    reg [4:0] mem_reg;

    // Pipeline stages
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 0;
            instruction_reg <= 0;
            decoded_reg <= 0;
            exec_reg <= 0;
            mem_reg <= 0;
            pc_out <= 0;
            decoded_output <= 0;
            exec_output <= 0;
            mem_output <= 0;
            write_back_output <= 0;
        end else begin
            // IF Stage
            pc <= pc + 1;
            pc_out <= pc;

            // ID Stage
            instruction_reg <= instruction;
            decoded_reg <= instruction_reg;
            decoded_output <= decoded_reg;

            // EX Stage
            exec_reg <= decoded_reg; // Simple forwarding assumption
            exec_output <= exec_reg;

            // MEM Stage
            mem_reg <= exec_reg; // Simple forwarding assumption
            mem_output <= mem_reg;

            // WB Stage
            write_back_output <= mem_reg; // Simple forwarding assumption
        end
    end
endmodule