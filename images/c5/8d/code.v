module mux_2to1(
    input A,
    input B,
    input S,
    output reg Y
);

    always @(*) begin
        if(S == 0) begin
            Y = A;
        end
        else begin
            Y = B;
        end
    end

endmodule