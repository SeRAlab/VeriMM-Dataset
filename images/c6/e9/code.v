module square_module(
    input [3:0] num,
    output reg [7:0] square
);

always @(*) begin
    square = num * num;
end

endmodule