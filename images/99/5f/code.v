module top_module(
    output Q,
    input D,
    input GATE,
    input RESET
);reg Q_int;

    always @ (posedge GATE or negedge RESET) begin
        if (RESET == 0) begin
            Q_int <= 0;
        end else if (GATE == 1) begin
            Q_int <= D;
        end
    end

    assign Q = Q_int;

endmodule