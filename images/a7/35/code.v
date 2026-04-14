module top_module(
    input [3:0] a,
    input [3:0] b,
    input enable,
    output reg signed [7:0] result
);// Initialize the result to 0
initial begin
    result = 0;
end

// Multiplication process
always @(*) begin
    if (enable == 1) begin
        result = $signed(a) * $signed(b);
    end else begin
        result = 0;
    end
end

endmodule