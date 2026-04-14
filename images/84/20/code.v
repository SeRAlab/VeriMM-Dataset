module top_module();// Inputs are registered
    reg A;
    reg VPWR;
    reg VGND;

    // Outputs are wires
    wire X;

    assign X = (A && VPWR && !VGND);

    initial
    begin
        // Initial state is x for all inputs
        A    = 1'bX;
        VGND = 1'bX;
        VPWR = 1'bX;

        #20   A    = 1'b0;
        #40   VGND = 1'b0;
        #60   VPWR = 1'b0;
        #80   A    = 1'b1;
        #100  VGND = 1'b1;
        #120  VPWR = 1'b1;
        #140  A    = 1'b0;
        #160  VGND = 1'b0;
        #180  VPWR = 1'b0;
        #200  VPWR = 1'b1;
        #220  VGND = 1'b1;
        #240  A    = 1'b1;
        #260  VPWR = 1'bx;
        #280  VGND = 1'bx;
        #300  A    = 1'bx;
    end

    // Instantiate a correct module or remove this line if not needed
    // sky130_fd_sc_hs__dlymetal6s6s dut (.A(A), .VPWR(VPWR), .VGND(VGND), .X(X));
    // Replace the above line with the appropriate module or create a dummy module for testing
    // Example:
    // assign X = (A && VPWR && !VGND); // Use this until a valid module is defined

endmodule