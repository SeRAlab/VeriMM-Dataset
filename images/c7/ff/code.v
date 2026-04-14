module shift_left (
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] out
);

always @(*) begin
    if (B > 3) begin
        out <= 4'b0;
    end else begin
        out <= A << B;
    end
end

endmodule