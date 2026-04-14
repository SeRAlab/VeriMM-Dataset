module top_module(
    input D,
    input R,
    output Q,
    output Q_N
);reg Q_int;

    always @(D, R)
    begin
        if (R == 1'b1) begin
            Q_int <= 1'b0;
        end
        else begin
            Q_int <= D;
        end
    end

    assign Q = Q_int;
    assign Q_N = ~Q_int;

endmodule