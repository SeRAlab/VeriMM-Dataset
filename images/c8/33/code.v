module multiplier(
    input [7:0] A,
    input [7:0] B,
    input [7:0] C,
    input [7:0] D,
    input [7:0] E,
    output reg [15:0] Y
);

    always @(*) begin
        Y = (A * B) + (C * D * E);
    end

endmodule