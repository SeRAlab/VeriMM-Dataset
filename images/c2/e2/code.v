module priority_encoder (
    input [1:0] in,
    output reg [1:0] out
);

reg [1:0] stage1_out;
reg [1:0] stage2_out;

always @(*) begin
    stage1_out[0] = in[0] | in[1];
    stage1_out[1] = in[0] & in[1];
end

always @(posedge clk) begin
    stage2_out <= stage1_out;
end

always @(*) begin
    if (stage2_out[1] == 1'b1) begin
        out <= 2'b10;
    end else if (stage2_out[0] == 1'b1) begin
        out <= 2'b01;
    end else begin
        out <= 2'b00;
    end
end

endmodule