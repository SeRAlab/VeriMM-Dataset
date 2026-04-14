module arithmetic_module(
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] C
);

    always @ (A, B) begin
        C = A + B;
        if (C > 16'hFFFF) begin
            C = C[15:0];
        end
    end

endmodule