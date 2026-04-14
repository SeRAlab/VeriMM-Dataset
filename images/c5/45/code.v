module comparator (
    input [1:0] in_0,
    input [1:0] in_1,
    output reg [1:0] out
);

always @(*) begin
    if (in_0 > in_1) begin
        out <= 2'b01;
    end else if (in_0 == in_1) begin
        out <= 2'b10;
    end else begin
        out <= 2'b00;
    end
end

endmodule