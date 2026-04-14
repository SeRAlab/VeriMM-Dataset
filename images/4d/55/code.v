module top_module(
    input D,
    input RESET_B,
    input SET_B,
    input CLK,
    output Q
);reg Q_int;

    always @(posedge CLK or negedge RESET_B or negedge SET_B)
    begin
        if (!RESET_B) // Asynchronous reset
            Q_int <= 1'b0;
        else if (!SET_B) // Asynchronous set
            Q_int <= 1'b1;
        else // Synchronous logic
            Q_int <= D;
    end

    assign Q = Q_int;

endmodule