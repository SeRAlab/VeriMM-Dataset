module top_module(
    input [3:0] G,
    output reg [3:0] B
);reg [3:0] stage1;
reg [3:0] stage2;
reg [3:0] stage3;

always @(G) begin
    stage1[0] = G[0];
    stage1[1] = stage1[0] ^ G[1];
    stage1[2] = stage1[1] ^ G[2];
    stage1[3] = stage1[2] ^ G[3];
end

always @(stage1) begin
    stage2[0] = stage1[0];
    stage2[1] = stage1[1] ^ stage2[0];
    stage2[2] = stage1[2] ^ stage2[1];
    stage2[3] = stage1[3] ^ stage2[2];
end

always @(stage2) begin
    stage3[0] = stage2[0];
    stage3[1] = stage2[1] ^ stage3[0];
    stage3[2] = stage2[2] ^ stage3[1];
    stage3[3] = stage2[3] ^ stage3[2];
end

assign B = stage3;

endmodule