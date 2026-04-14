module top_module(
    input clk,
    input reset,
    input [3:0] op,
    input [31:0] input1,
    input [31:0] input2,
    output reg [31:0] result,
    output reg zero,
    output reg overflow
);always @(posedge clk) begin
    if (reset) begin
        result <= 0;
        zero <= 0;
        overflow <= 0;
    end else begin
        case (op)
            4'b0000: result <= input1 & input2;
            4'b0001: result <= input1 | input2;
            4'b0010: result <= input1 ^ input2;
            4'b0011: result <= input1 + input2;
            4'b0100: result <= input1 - input2;
            4'b0101: result <= input1 << input2[4:0];
            4'b0110: result <= input1 >> input2[4:0];
            4'b0111: result <= $signed(input1) >>> input2[4:0];
            4'b1000: result <= (input1 < input2) ? 1 : 0;
        endcase

        zero <= (result == 0) ? 1 : 0;

        if (op == 4'b0011 || op == 4'b0100) begin
            if ((input1[31] == input2[31]) && (result[31] != input1[31])) begin
                overflow <= 1;
            end else begin
                overflow <= 0;
            end
        end else begin
            overflow <= 0;
        end
    end
end

endmodule