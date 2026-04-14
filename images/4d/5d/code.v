module top_module(
    input D,
    input CLK,
    input SET,
    input SLEEP_B,
    input KAPWR,
    input VGND,
    input VPWR,
    output reg Q
);always @(posedge CLK or posedge SET) begin
    if (SET) begin
        Q <= 1'b1; // Set Q to 1 when SET is high
    end else if (KAPWR) begin
        Q <= D;    // On clock edge, if KAPWR is active, latch D into Q
    end
end

endmodule