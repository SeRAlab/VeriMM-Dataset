module multiplexer
(
    input [7:0] a,
    input [7:0] b,
    input sel,
    output reg [7:0] y
);always @(*)
    if (sel) begin
        y <= b;
    end else begin
        y <= a;
    end
endmodule