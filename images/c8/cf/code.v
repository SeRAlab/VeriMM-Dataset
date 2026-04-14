module mux_2to1 (
    input [2:0] A,
    input [2:0] B,
    input S,
    output reg [2:0] Y
);

always @(*) begin
    if (S == 1'b0) begin
        Y = A;
    end else begin
        Y = B;
    end
end

endmodule