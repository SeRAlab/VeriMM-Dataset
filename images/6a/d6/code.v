module top_module(
    Q,
    RESET_B,
    D,
    GATE_N
);output Q;
    input RESET_B, D, GATE_N;

    reg Q;

    always @(posedge GATE_N or negedge RESET_B) begin
        if (!RESET_B) begin
            Q <= 1'b0;
        end else if (!GATE_N) begin
            Q <= Q;
        end else begin
            Q <= D;
        end
    end

endmodule