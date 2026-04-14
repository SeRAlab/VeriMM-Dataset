module ab_mux (
    input a,
    input b,
    output reg q
);

always @(*) begin
    if (a == 0 && b == 0) begin
        q = 0;
    end else if (a == 0) begin
        q = b;
    end else begin
        q = a;
    end
end

endmodule