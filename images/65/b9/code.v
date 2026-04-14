module top_module(
    input A,
    input B,
    input C,
    input D,
    output reg [1:0] X,
    output reg Y
);reg [1:0] stage1_out;
reg [1:0] stage2_out;

always @(A or B or C or D) begin
    stage1_out[0] <= A | B;
    stage1_out[1] <= C | D;
end

always @(stage1_out) begin
    stage2_out[0] <= stage1_out[0] | stage1_out[1];
    stage2_out[1] <= stage1_out[0] & stage1_out[1];
end

always @(stage2_out) begin
    if (stage2_out[1]) begin
        X <= 2'b00;
        Y <= stage2_out[0];
    end else if (stage2_out[0]) begin
        X <= 2'b01;
        Y <= stage1_out[1];
    end else if (stage1_out[1]) begin
        X <= 2'b10;
        Y <= stage1_out[0];
    end else begin
        X <= 2'b11;
        Y <= 1'b0;
    end
end

endmodule