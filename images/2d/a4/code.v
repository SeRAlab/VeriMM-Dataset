module instruction_pipeline(
    input wire clk,
    input wire reset,
    input wire [15:0] instruction,
    output reg [3:0] output_signal
);
    reg [15:0] instruction_reg;
    reg [3:0] opcode;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            instruction_reg <= 16'b0;
            output_signal <= 4'b0;
        end else begin
            instruction_reg <= instruction;
            opcode <= instruction_reg[15:12];
            case (opcode)
                4'b0000: output_signal <= 4'b0001;
                4'b0001: output_signal <= 4'b0010;
                4'b0010: output_signal <= 4'b0011;
                4'b0011: output_signal <= 4'b0100;
                default: output_signal <= 4'b0000;
            endcase
        end
    end
endmodule