module top_module(
    input a,
    input b,
    output reg out
);reg stage1_out;
reg stage2_out;

always @ (a, b) begin
    stage1_out <= a ^ b;
end

always @ (stage1_out) begin
    stage2_out <= stage1_out;
end

always @ (stage2_out) begin
    out <= stage2_out;
end

endmodule