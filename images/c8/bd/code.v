module mux_2to1(
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output reg out_always
);

always @(*) begin
    if (sel_b1 && sel_b2) begin
        out_always = b;
    end else begin
        out_always = a;
    end
end

endmodule