module mux21_reg(
    input I0,
    input I1,
    input S,
    input clk,
    output reg O
);

always @(posedge clk) begin
    if (S == 0) begin
        O <= I0;
    end else begin
        O <= I1;
    end
end

endmodule