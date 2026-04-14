module nor_gate_with_enable (
    input in1,
    input in2,
    input en,
    output out
);

reg out_reg;

always @(*) begin
    if (en == 1'b0) begin
        out_reg = 1'b0;
    end else begin
        out_reg = ~(in1 | in2);
    end
end

assign out = out_reg;

endmodule