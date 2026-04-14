module my_module (
    Q,
    Q_N,
    CLK,
    D
);

    output Q;
    output Q_N;
    input CLK;
    input D;

    reg Q;

    always @(posedge CLK) begin
        Q <= D;
    end

    assign Q_N = ~Q;

endmodule