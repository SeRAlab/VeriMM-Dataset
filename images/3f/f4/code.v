module D_latch (
    input wire D,
    input wire E,
    output reg Q,
    output reg Q_bar
);
    always @(D or E) begin
        if (E) begin
            Q <= D;
        end
        // Q retains its value when E is low
        Q_bar <= ~Q;  // Complementary output
    end
endmodule