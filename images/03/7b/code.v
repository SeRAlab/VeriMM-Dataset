module butterworth_filter (
    input [7:0] x0,
    input [7:0] x1,
    input [7:0] x2,
    output reg [7:0] y
);

always @(*) begin
    y = (1 * x0 + 2 * x1 + 1 * x2) / 4;
end

endmodule