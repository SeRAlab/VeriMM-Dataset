module top_module(
    input D,
    input CLK,
    output Q
);reg Q_reg;

    always @(posedge CLK)
    begin
        Q_reg <= D;
    end

    assign Q = Q_reg;

endmodule