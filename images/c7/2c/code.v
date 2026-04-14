module addsub_4bit (
    input [3:0] A,
    input [3:0] B,
    input S,
    output reg [3:0] F
);

always @(*) begin
    if (S == 0) begin
        F = A + B;
    end else begin
        F = A - B;
    end
end

endmodule