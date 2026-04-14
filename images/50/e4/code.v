module top_module(
    input a,
    input b,
    output reg out_comb_logic
);reg [1:0] stage1_out;
reg [1:0] stage2_out;

always @(a, b)
begin
    stage1_out[0] <= a ^ b;
end

always @(stage1_out)
begin
    stage1_out[1] <= stage1_out[0];
end

always @(stage1_out)
begin
    stage2_out[0] <= stage1_out[1];
end

always @(stage2_out)
begin
    stage2_out[1] <= stage2_out[0];
end

assign out_comb_logic = stage2_out[1];

endmodule