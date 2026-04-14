module mux_2_to_1 (
    output reg Y,
    input A,
    input B,
    input S
);

always @(*) begin
    if (S == 0) begin
        Y = A;
    end else begin
        Y = B;
    end
end

endmodule