module top_module(
    input A,
    input B,
    input enable,
    output reg C
);always @(A, B, enable) begin
    if (enable) begin
        C <= A + B;
    end
end

endmodule