module top_module(
    input D,
    input S,
    input R,
    input CLK,
    output Q
);reg Q_int;

    always @(posedge CLK) begin
        if (S) begin
            Q_int <= 1;
        end else if (R) begin
            Q_int <= 0;
        end else begin
            Q_int <= D;
        end
    end

    assign Q = Q_int;

endmodule