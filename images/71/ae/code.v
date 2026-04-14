module top_module(
    input clk,
    input rst,
    input [1:0] op,
    input signed [7:0] a,
    input signed [7:0] b,
    output reg signed [7:0] result
);reg signed [15:0] temp;

always @(posedge clk) begin
    if (rst) begin
        result <= 8'b0;
    end else begin
        case(op)
            2'b00: result <= a + b;
            2'b01: result <= a - b;
            2'b10: begin
                temp <= a * b;
                result <= temp[7:0];
            end
            2'b11: begin
                if (b == 0) begin
                    result <= 8'b0;
                end else begin
                    temp <= a / b;
                    result <= temp[7:0];
                end
            end
        endcase
    end
end

endmodule