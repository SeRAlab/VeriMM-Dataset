module top_module(
    output Q,
    output Q_N,
    input CLK,
    input D,
    input RESET_B
);// Declare internal flip-flop signals
    reg Q_int;
    wire Q_N_int;

    // Instantiate D flip-flop with reset (example for a generic D flip-flop)
    always @(posedge CLK or negedge RESET_B) begin
        if (~RESET_B) 
            Q_int <= 1'b0; // Active low reset
        else 
            Q_int <= D;
    end

    // Provide Q_N directly as the complement of Q_int
    assign Q_N = ~Q_int;

    // Assign outputs
    assign Q = Q_int;

endmodule