module top_module(
    input clk,
    input rst,
    input [1:0] op,
    input signed [7:0] a,
    input signed [7:0] b,
    output reg signed [7:0] out,
    output reg overflow
);always @(posedge clk) begin
    if (rst) begin
        out <= 0;
        overflow <= 0;
    end else begin
        case(op)
            2'b00: begin // addition
                out <= a + b;
                overflow <= ((a > 0) && (b > 0) && (out < 0)) || ((a < 0) && (b < 0) && (out > 0));
            end
            2'b01: begin // subtraction
                out <= a - b;
                overflow <= ((a > 0) && (b < 0) && (out < 0)) || ((a < 0) && (b > 0) && (out > 0));
            end
            2'b10: begin // multiplication
                out <= a * b;
                overflow <= ((out[7] == 1) && (out != -128)) || (out == -128);
            end
            2'b11: begin // division
                if (b == 0) begin
                    out <= 0;
                    overflow <= 1;
                end else begin
                    out <= a / b;
                    overflow <= 0;
                end
            end
        endcase
    end
end

endmodule