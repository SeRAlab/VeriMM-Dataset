module top_module(
    input [3:0] A,
    input [3:0] B,
    input clk,               // Added input for the clock signal
    output reg [7:0] product
);reg [4:0] m;
reg [7:0] a, s;

always @(*) begin
    a = {A, 4'b0};
    s = {B, 4'b0};
    m = 5'b10010;
end

always @(posedge clk) begin
    if (s[0] == 1) begin
        product <= product + a;
    end
    if (s[3:1] == 3'b111) begin
        product <= product - a;
    end
    if (s[3:1] == 3'b001 || s[3:1] == 3'b010) begin
        product <= product + (a << 1);
    end
    if (s[3:1] == 3'b101 || s[3:1] == 3'b110) begin
        product <= product - (a << 1);
    end
    m <= {m[3:1], s[0]};       // Fixed the assignments to m
    s <= {s[3], s[3:1]};       // Adjusted the shifting of s
end

endmodule