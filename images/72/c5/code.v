module top_module(
    input  D,
    output Q,
    input  SCD,
    input  SCE,
    input  CLK
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    // Flip-flop for storing input value
    reg stored_D;
    always @(posedge CLK) begin
        if (SCE) stored_D <= SCD;
        else stored_D <= D;
    end

    // Combinational logic for generating output
    assign Q = stored_D;

endmodule