module top_module(
    input [31:0] data,
    input [4:0] shift,
    input shift_right,
    output reg [31:0] shifted_data
);reg [31:0] stage1_out;
reg [31:0] stage2_out;
reg [31:0] stage3_out;
reg [31:0] stage4_out;

always @(*) begin
    if (shift_right) begin
        stage1_out = data >> 1;
    end else begin
        stage1_out = data << 1;
    end
end

always @(*) begin
    if (shift_right) begin
        stage2_out = stage1_out >> 2;
    end else begin
        stage2_out = stage1_out << 2;
    end
end

always @(*) begin
    if (shift_right) begin
        stage3_out = stage2_out >> 4;
    end else begin
        stage3_out = stage2_out << 4;
    end
end

always @(*) begin
    if (shift_right) begin
        stage4_out = stage3_out >> 8;
    end else begin
        stage4_out = stage3_out << 8;
    end
end

always @(*) begin
    if (shift_right) begin
        shifted_data = stage4_out >> shift;
    end else begin
        shifted_data = stage4_out << shift;
    end
end

endmodule