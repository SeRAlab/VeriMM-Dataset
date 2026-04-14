module top_module(
    input in1,
    input in2,
    input reset,
    output reg out1
);always @(*) begin
    if (reset) begin
        out1 <= 1'b0;
    end else begin
        out1 <= in1 ^ in2;
    end
end

endmodule