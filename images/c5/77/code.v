module add4bit (
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] Y
);

always @* begin
    Y = A + B;
    if (Y > 15) begin
        Y = Y[3:0];
    end
end

endmodule