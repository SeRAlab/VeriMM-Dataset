module mux_2to1 (
    input in0,
    input in1,
    input sel,
    output reg out
);

always @(*) begin
    if (sel == 1'b0) begin
        out = in0;
    end else begin
        out = in1;
    end
end

endmodule