module mod4sum(
    input A,
    input B,
    input C,
    input D,
    output reg [1:0] Y
);

    always @ (A, B, C, D) begin
        Y = {A, B} + {C, D};
        if (Y >= 4) Y = Y - 4;
    end

endmodule