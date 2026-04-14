module add4bit(
    input [3:0] A,
    input [3:0] B,
    output reg [4:0] SUM
);

always @(*) begin
    SUM = A + B;
    if (SUM > 15) begin
        SUM = SUM + 16;
        SUM[4] = 1;
    end else begin
        SUM[4] = 0;
    end
end

endmodule