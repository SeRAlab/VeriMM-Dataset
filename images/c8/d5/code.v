module adder(
    input [7:0] A,
    input [7:0] B,
    output reg [7:0] Y
);

always @(*) begin
    if (A + B > 255) begin
        Y <= 255;
    end else begin
        Y <= A + B;
    end
end

endmodule