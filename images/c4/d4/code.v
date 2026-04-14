module logic_function (
    input A1,
    input A2,
    input B1,
    input B2,
    input C1,
    input C2,
    output reg X
);

    always @(*) begin
        X = (A1 & A2) | (B1 & B2) | (C1 & C2);
    end

endmodule