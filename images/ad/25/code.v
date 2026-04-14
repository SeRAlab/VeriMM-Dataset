module top_module(
    input [3:0] in,
    output reg out
);reg [1:0] stage1_out;
reg [1:0] stage2_out;

always @ (in) begin
    stage1_out[0] <= in[0] | in[2];
    stage1_out[1] <= in[1] | in[3];
end

always @ (stage1_out) begin
    stage2_out[0] <= stage1_out[0] | stage1_out[1];
    stage2_out[1] <= stage1_out[0] & stage1_out[1];
end

always @ (stage2_out) begin
    if (stage2_out[1]) begin
        out <= in[3];
    end else if (stage2_out[0]) begin
        out <= in[2];
    end else if (stage1_out[1]) begin
        out <= in[1];
    end else begin
        out <= in[0];
    end
end

endmodule