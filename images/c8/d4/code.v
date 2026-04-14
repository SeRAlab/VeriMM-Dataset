module my_module (
    input A1,
    input A2,
    input B1,
    input C1,
    output reg X
);

    always @(*) begin
        if ((A1 & A2) || (B1 & C1))
            X = 1;
        else
            X = 0;
    end

endmodule