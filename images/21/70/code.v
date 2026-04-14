module max_heap (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output reg [7:0] max
);
    always @(*) begin
        max = a; // Start with the first input
        if (b > max) max = b;
        if (c > max) max = c;
        if (d > max) max = d;
    end
endmodule