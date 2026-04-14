module top_module(
    input signed [31:0] a,
    input signed [31:0] b,
    input [1:0] mode,
    output reg signed [31:0] sum,
    output reg signed [31:0] difference,
    output reg signed [31:0] product,
    output reg signed [31:0] quotient
);always @(*) begin
    case (mode)
        2'b00: begin
            sum = a + b;
            difference = 0;
            product = 0;
            quotient = 0;
        end
        2'b01: begin
            sum = 0;
            difference = a - b;
            product = 0;
            quotient = 0;
        end
        2'b10: begin
            sum = 0;
            difference = 0;
            product = a * b;
            quotient = 0;
        end
        2'b11: begin
            sum = 0;
            difference = 0;
            product = 0;
            quotient = a / b;
        end
    endcase
end

endmodule