module instruction_pipeline(
    input wire clk,
    input wire reset,
    input wire [31:0] instruction_in,
    output reg [31:0] instruction_out,
    output reg stall
);

    reg [31:0] IF_ID_instruction;
    reg [31:0] ID_EX_instruction;
    reg [31:0] EX_MEM_instruction;
    reg [31:0] MEM_WB_instruction;

    reg [1:0] stage;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            IF_ID_instruction <= 32'b0;
            ID_EX_instruction <= 32'b0;
            EX_MEM_instruction <= 32'b0;
            MEM_WB_instruction <= 32'b0;
            instruction_out <= 32'b0;
            stall <= 1'b0;
            stage <= 2'b00;
        end else begin
            case (stage)
                2'b00: begin
                    IF_ID_instruction <= instruction_in;
                    stage <= 2'b01;
                end
                2'b01: begin
                    ID_EX_instruction <= IF_ID_instruction;
                    stage <= 2'b10;
                end
                2'b10: begin
                    EX_MEM_instruction <= ID_EX_instruction;
                    stage <= 2'b11;
                end
                2'b11: begin
                    MEM_WB_instruction <= EX_MEM_instruction;
                    instruction_out <= MEM_WB_instruction;
                    stage <= 2'b00;
                end
            endcase
        end
    end
endmodule