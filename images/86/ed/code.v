module top_module(
    input signed [7:0] a,
    input signed [7:0] b,
    input [1:0] op,
    output reg signed [7:0] result,
    output reg overflow
);always @(*) begin
        case(op)
            2'b00: result = a + b;
            2'b01: result = a - b;
            2'b10: result = a * b;
            2'b11: result = a / b;
        endcase
    end

    always @(result) begin
        if(result > 127 || result < -128) begin
            overflow = 1;
        end else begin
            overflow = 0;
        end
    end

endmodule