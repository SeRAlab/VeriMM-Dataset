module top_module(
    input [7:0] A,
    input [7:0] B,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg valid
);always @(*) begin
    if (B == 0) begin
        quotient <= 8'b0;
        remainder <= 8'b0;
        valid <= 1'b1;
    end else begin
        quotient <= A / B;
        remainder <= A % B;
        valid <= 1'b1;
    end
end

endmodule