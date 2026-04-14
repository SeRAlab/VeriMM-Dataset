module top_module(
    input CLK,
    input D,
    input SET,
    input CLR,
    output Q,
    output Q_N
);wire Q_int;
    
    // Instantiate a proper D flip-flop primitive if the module is missing
    // For example, using a simple behavioral model instead
    reg Q_int_reg;

    always @(posedge CLK or posedge SET or posedge CLR) begin
        if (CLR)
            Q_int_reg <= 0;
        else if (SET)
            Q_int_reg <= 1;
        else
            Q_int_reg <= D;
    end

    assign Q_int = Q_int_reg;
    assign Q_N = ~Q_int_reg;

endmodule