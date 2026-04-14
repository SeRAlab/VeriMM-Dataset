module top_module();// Inputs are registered
    reg VPWR;
    reg VGND;

    // Outputs are wires
    wire tap_out;

    // Instantiate sky130_fd_sc_hs__tap module
    // Assuming the sky130_fd_sc_hs__tap module is defined correctly elsewhere
    // If it is not defined, you need to include its definition or find the correct module.
    // Uncomment the next line if you have the definition available.
    // sky130_fd_sc_hs__tap dut (.VPWR(VPWR), .VGND(VGND), .TAP_OUT(tap_out));

    initial
    begin
        // Initial state is x for all inputs.
        VGND = 1'bX;
        VPWR = 1'bX;

        #20   VGND = 1'b0;
        #40   VPWR = 1'b0;
        #60   VGND = 1'b1;
        #80   VPWR = 1'b1;
        #100  VGND = 1'b0;
        #120  VPWR = 1'b0;
        #140  VPWR = 1'b1;
        #160  VGND = 1'b1;
        #180  VPWR = 1'bx;
        #200  VGND = 1'bx;
    end

endmodule