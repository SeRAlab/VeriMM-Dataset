module bitwise_or(
    input A,
    input B,
    output reg P
);

    always @ (A or B) begin
        P = A | B;
    end

endmodule