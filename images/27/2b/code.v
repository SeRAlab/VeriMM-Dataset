module quarter_round (
    input  [31:0] v0,
    input  [31:0] v1,
    input  [31:0] v2,
    input  [31:0] v3,
    output reg [31:0] o0,
    output reg [31:0] o1,
    output reg [31:0] o2,
    output reg [31:0] o3,
    input clk,
    input rst
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            o0 <= 0;
            o1 <= 0;
            o2 <= 0;
            o3 <= 0;
        end else begin
            // Quarter round transformation
            o0 <= v0 + v1;
            o1 <= v1 ^ ((o0 << 16) | (o0 >> (32 - 16)));
            o2 <= v2 + o1;
            o3 <= v3 ^ ((o2 << 12) | (o2 >> (32 - 12)));
            o0 <= o0 + o1;
            o1 <= o1 ^ ((o3 << 8) | (o3 >> (32 - 8)));
            o2 <= o2 + o3;
            o3 <= o3 ^ ((o1 << 7) | (o1 >> (32 - 7)));
        end
    end
endmodule