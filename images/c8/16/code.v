module mux2to1 (
    input A,
    input B,
    input SEL,
    output reg Y
);

    always @(*) begin
        if(SEL == 0) begin
            Y = A;
        end else begin
            Y = B;
        end
    end

endmodule