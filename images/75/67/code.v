module top_module();// Inputs are registered
    reg A1;
    reg A2;
    reg A3;
    reg B1;
    reg C1;
    reg VPWR;
    reg VGND;
    reg VPB;
    reg VNB;

    // Outputs are wires
    wire Y;

    // Instantiate the design module; ensure the module exists in the library or define it if missing.
    // Uncomment the following line if the module needs to be defined.
    // sky130_fd_sc_lp__o311ai dut (.A1(A1), .A2(A2), .A3(A3), .B1(B1), .C1(C1), .VPWR(VPWR), .VGND(VGND), .VPB(VPB), .VNB(VNB), .Y(Y));

    initial
    begin
        // Initial state is x for all inputs.
        A1   = 1'bX;
        A2   = 1'bX;
        A3   = 1'bX;
        B1   = 1'bX;
        C1   = 1'bX;
        VGND = 1'bX;
        VNB  = 1'bX;
        VPB  = 1'bX;
        VPWR = 1'bX;

        #20   A1   = 1'b0;
        #40   A2   = 1'b0;
        #60   A3   = 1'b0;
        #80   B1   = 1'b0;
        #100  C1   = 1'b0;
        #120  VGND = 1'b0;
        #140  VNB  = 1'b0;
        #160  VPB  = 1'b0;
        #180  VPWR = 1'b0;
        #200  A1   = 1'b1;
        #220  A2   = 1'b1;
        #240  A3   = 1'b1;
        #260  B1   = 1'b1;
        #280  C1   = 1'b1;
        #300  VGND = 1'b1;
        #320  VNB  = 1'b1;
        #340  VPB  = 1'b1;
        #360  VPWR = 1'b1;
        #380  A1   = 1'b0;
        #400  A2   = 1'b0;
        #420  A3   = 1'b0;
        #440  B1   = 1'b0;
        #460  C1   = 1'b0;
        #480  VGND = 1'b0;
        #500  VNB  = 1'b0;
        #520  VPB  = 1'b0;
        #540  VPWR = 1'b0;
        #560  VPWR = 1'b1;
        #580  VPB  = 1'b1;
        #600  VNB  = 1'b1;
        #620  VGND = 1'b1;
        #640  C1   = 1'b1;
        #660  B1   = 1'b1;
        #680  A3   = 1'b1;
        #700  A2   = 1'b1;
        #720  A1   = 1'b1;
        #740  VPWR = 1'bx;
        #760  VPB  = 1'bx;
        #780  VNB  = 1'bx;
        #800  VGND = 1'bx;
        #820  C1   = 1'bx;
        #840  B1   = 1'bx;
        #860  A3   = 1'bx;
        #880  A2   = 1'bx;
        #900  A1   = 1'bx;
    end

endmodule