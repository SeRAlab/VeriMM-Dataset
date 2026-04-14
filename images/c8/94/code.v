module addsub_8bit (
    input [7:0] A,
    input [7:0] B,
    input C,
    output reg [7:0] S
);

always @(*) begin
    if (C == 1) begin
        S = A + B;
    end else begin
        S = A - B;
    end
end

endmodule