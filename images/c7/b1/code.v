module compare (
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out
);

always @(a, b) begin
    if(a >= b) begin
        out = a - b;
    end else begin
        out = a + b;
    end
end

endmodule