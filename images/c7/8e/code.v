module Latch(
    input D, CLK,
    output Q, Q_bar
);

reg Q, Q_bar, D_prev;

always @(posedge CLK) begin
    Q <= D_prev;
    Q_bar <= ~D_prev;
    D_prev <= D;
end

endmodule