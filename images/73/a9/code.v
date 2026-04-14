module top_module(
    input wire D,
    input wire DATA_EN,
    input wire VPWR,
    input wire VGND,
    input wire CLK,
    output reg Q
);// Removed the instantiation of the undefined module
    // sky130_fd_sc_hs__udp_dff$PE_pp$PG dut (.D(D), .DATA_EN(DATA_EN), .VPWR(VPWR), .VGND(VGND), .Q(Q), .CLK(CLK)); 

    always @ (posedge CLK) begin
        if (DATA_EN) begin
            Q <= D; // Update output Q with D if DATA_EN is high
        end else if (VPWR) begin
            Q <= 0; // Reset Q to 0 if VPWR is high and DATA_EN is low
        end else if (VGND) begin
            Q <= 1; // Set Q to 1 if VGND is high and DATA_EN is low
        end
    end

endmodule