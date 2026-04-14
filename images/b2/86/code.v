module top_module(
    input  RESET_B,
    input  CLK    ,
    input  D      ,
    output Q      ,
    output Q_N
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    // Instantiate the D Flip-Flop with reset
    // Replacing the missing module with a behavioral description
    reg Q_internal;
    assign Q = Q_internal;
    assign Q_N = ~Q;

    always @(posedge CLK or negedge RESET_B) begin
        if (!RESET_B)
            Q_internal <= 1'b0;  // Active low reset
        else
            Q_internal <= D;      // Data input on rising edge of CLK
    end

endmodule