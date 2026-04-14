module top_module(
    input clk,
    input rst_n,
    input [1:0] op,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] result,
    output reg overflow
);reg [15:0] mult_result;
reg [15:0] div_result;
reg [7:0] twos_comp_b;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 8'b0;
        overflow <= 1'b0;
    end else begin
        case (op)
            2'b00: begin // addition
                result <= a + b;
                overflow <= (a[7] == b[7] && result[7] != a[7]);
            end
            2'b01: begin // subtraction
                result <= a - b;
                overflow <= (a[7] != b[7] && result[7] != a[7]);
            end
            2'b10: begin // multiplication
                mult_result <= a * b;
                result <= mult_result[7:0];
                overflow <= mult_result[15:8] != 0;
            end
            2'b11: begin // division
                if (b == 8'b0) begin
                    result <= 8'b0;
                    overflow <= 1'b1;
                end else begin
                    div_result <= a / b;
                    result <= div_result[7:0];
                    overflow <= 1'b0;
                end
            end
        endcase
    end
end

// calculate twos complement of b for subtraction
always @(*) begin
    twos_comp_b = (~b) + 1;
end

endmodule