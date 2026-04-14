module top_module(
    input D,
    input CLK,
    input SET,
    input RESET,
    input CE,
    output reg Q,
    output reg Q_N
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Flip-flop implementation
    always @(posedge CLK or negedge CE) begin
        if (CE == 0) begin
            Q <= Q;
            Q_N <= Q_N;
        end else if (SET == 0) begin
            Q <= 1'b1;
            Q_N <= 1'b0;
        end else if (RESET == 0) begin
            Q <= 1'b0;
            Q_N <= 1'b1;
        end else begin
            Q <= D;
            Q_N <= ~D;
        end
    end

endmodule