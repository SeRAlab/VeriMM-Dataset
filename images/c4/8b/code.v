module mux_2to1(
    input A, B, S,
    output Y
);

    reg Y;

    always @ (A, B, S)
    begin
        if (S == 1'b1)
            Y = A;
        else
            Y = B;
    end

    assign Y = Y;

endmodule