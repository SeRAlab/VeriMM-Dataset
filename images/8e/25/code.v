module top_module(
    input clk,
    input rst,
    input [7:0] operand1,
    input [7:0] operand2,
    input [1:0] opcode,
    output [7:0] result,
    output ovf,
    output unf
);reg [15:0] temp_result;
    reg [7:0] temp_result_lo;
    reg [7:0] temp_result_hi;
    reg ovf_reg;
    reg unf_reg;

    always @(posedge clk) begin
        if (rst) begin
            temp_result <= 0;
            ovf_reg <= 0;
            unf_reg <= 0;
        end else begin
            case (opcode)
                2'b00: temp_result <= operand1 + operand2;
                2'b01: temp_result <= operand1 - operand2;
                2'b10: temp_result <= operand1 * operand2;
                2'b11: begin
                    if (operand2 == 0) begin
                        temp_result <= 0;
                        ovf_reg <= 0;
                        unf_reg <= 0;
                    end else begin
                        temp_result <= operand1 / operand2;
                        if (temp_result > 255) begin
                            temp_result <= 255;
                            ovf_reg <= 1;
                        end else if (temp_result < 0) begin
                            temp_result <= 0;
                            unf_reg <= 1;
                        end
                    end
                end
            endcase
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            temp_result_lo <= 0;
            temp_result_hi <= 0;
        end else begin
            temp_result_lo <= temp_result[7:0];
            temp_result_hi <= temp_result[15:8];
        end
    end

    assign result = {temp_result_hi, temp_result_lo};
    assign ovf = ovf_reg;
    assign unf = unf_reg;

endmodule