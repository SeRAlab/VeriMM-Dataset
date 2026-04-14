module top_module(
    input signed [22:0] Q,
    input signed [8:0] E,
    output reg overflow_flag,
    output reg underflow_flag,
    output reg signed [31:0] result
);reg signed [31:0] shifted_mantissa;

always @* begin
    if (E >= 0) begin
        shifted_mantissa = {Q, 23'h0} << E;
        overflow_flag = shifted_mantissa[31];
        underflow_flag = 0;
    end else begin
        shifted_mantissa = {Q, 23'h0} >>> (-E); // Changed abs(E) to -E
        overflow_flag = 0;
        underflow_flag = shifted_mantissa[7:0] != 8'h0;
    end
end

assign result = {1'b1, shifted_mantissa[30:0]} << (E + 127);

endmodule