module my_module (
    input A1,
    input A2,
    input B1_N,
    output reg X
);

always @(*) begin
    if (A1 && A2) begin
        X = 1;
    end else if (!A1) begin
        X = 0;
    end else begin
        X = ~B1_N;
    end
end

endmodule