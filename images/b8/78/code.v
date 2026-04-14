module top_module(
    input [15:0] dividend,
    input [15:0] divisor,
    output reg [15:0] quotient,
    output reg [15:0] remainder
);always @(*) begin
        if (divisor == 0) begin
            quotient <= 65535; // maximum value for 16-bit unsigned integer
            remainder <= 65535;
        end else begin
            quotient <= dividend / divisor;
            remainder <= dividend % divisor;
        end
    end

endmodule