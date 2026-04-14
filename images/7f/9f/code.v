module top_module(
    output Q,
    input CLK,
    input D,
    input SET_B
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Internal signal to store the flip-flop state
    reg Q_internal;

    // D flip-flop with asynchronous set functionality
    always @(posedge CLK or negedge SET_B) begin
        if (!SET_B) begin
            Q_internal <= 0;
        end else begin
            Q_internal <= D;
        end
    end

    // Assign the output port
    assign Q = Q_internal;

endmodule