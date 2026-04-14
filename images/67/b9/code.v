module top_module(
    output Q,
    input  D,
    input  GATE_N
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    reg prev_Q;

    always @(posedge GATE_N or negedge GATE_N) begin
        if (!GATE_N) begin
            prev_Q <= D;
        end
    end

    assign Q = GATE_N ? D : prev_Q;

endmodule