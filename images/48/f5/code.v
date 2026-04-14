module top_module(
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    output reg [15:0] a_out,
    output reg [15:0] b_out,
    output reg [15:0] c_out
);reg [15:0] ra = 16'h0000;
reg [15:0] rb = 16'h0000;
reg [15:0] rc = 16'h0000;

always @(a or ra) begin
    a_out = a + ra;
end

always @(b or rb) begin
    b_out = b + rb;
end

always @(c or rc) begin
    c_out = c + rc;
end

endmodule