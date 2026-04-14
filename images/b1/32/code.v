module top_module(
    input signed [31:0] a,
    input signed [31:0] b,
    input op,
    output reg signed [31:0] result,
    output reg valid
);always @(*) begin
    if (op == 0) begin
        result = a * b;
        valid = 1;
    end else if (op == 1) begin
        if (b != 0) begin
            result = a / b;
            valid = 1;
        end else begin
            valid = 0;
        end
    end
end

endmodule