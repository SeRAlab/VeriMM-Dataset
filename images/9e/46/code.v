module top_module(
    input [3:0] B,
    output reg [3:0] R,
    output reg [1:0] LZ
);reg [1:0] zeros;
reg [3:0] stage1, stage2, stage3;

always @(*) begin
    stage1[0] = B[3];
    stage1[1] = B[2];
    stage1[2] = B[1];
    stage1[3] = B[0];
end

always @(*) begin
    stage2[0] = stage1[2];
    stage2[1] = stage1[3];
    stage2[2] = stage1[0];
    stage2[3] = stage1[1];
end

always @(*) begin
    stage3[0] = stage2[1];
    stage3[1] = stage2[0];
    stage3[2] = stage2[3];
    stage3[3] = stage2[2];
end

always @(*) begin
    R = stage3;
end

always @(*) begin
    if (stage3[3] == 0) begin
        zeros = 2;
        if (stage3[2] == 0) begin
            zeros = 1;
            if (stage3[1] == 0) begin
                zeros = 0;
                if (stage3[0] == 0) begin
                    zeros = 0;
                end
            end
        end
    end
    else begin
        zeros = 0;
    end
    LZ = zeros;
end

endmodule