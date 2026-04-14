module top_module(
    input signed [15:0] in,
    output reg [15:0] out
);reg signed [15:0] stage1_out;
reg signed [15:0] stage2_out;

always @(in) begin
    stage1_out <= in;
end

always @(stage1_out) begin
    if (stage1_out < 0) begin
        stage2_out <= -stage1_out;
    end else begin
        stage2_out <= stage1_out;
    end
end

always @(stage2_out) begin
    out <= stage2_out;
end

endmodule