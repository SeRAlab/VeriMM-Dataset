module max_heap (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    output reg [3:0] max_out
);
    always @(*) begin
        max_out = a; // start with the first input
        if (b > max_out) max_out = b;
        if (c > max_out) max_out = c;
        if (d > max_out) max_out = d;
    end
endmodule