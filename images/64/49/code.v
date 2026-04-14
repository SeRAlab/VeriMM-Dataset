module top_module();// Inputs are registered
    reg VPWR;
    reg VGND;
    reg VPB;
    reg VNB;

    // Outputs are wires
    wire VPWR_out;
    wire VGND_out;
    wire VPB_out;
    wire VNB_out;

    initial
    begin
        // Initial state is x for all inputs.
        VGND = 1'bX;
        VNB  = 1'bX;
        VPB  = 1'bX;
        VPWR = 1'bX;

        #20   VGND = 1'b0;
        #40   VNB  = 1'b0;
        #60   VPB  = 1'b0;
        #80   VPWR = 1'b0;
        #100  VGND = 1'b1;
        #120  VNB  = 1'b1;
        #140  VPB  = 1'b1;
        #160  VPWR = 1'b1;
        #180  VGND = 1'b0;
        #200  VNB  = 1'b0;
        #220  VPB  = 1'b0;
        #240  VPWR = 1'b0;
        #260  VPWR = 1'b1;
        #280  VPB  = 1'b1;
        #300  VNB  = 1'b1;
        #320  VGND = 1'b1;
        #340  VPWR = 1'bx;
        #360  VPB  = 1'bx;
        #380  VNB  = 1'bx;
        #400  VGND = 1'bx;
    end

    // Replace this line with the appropriate module declaration
    // or ensure that the module is available in your compilation environment.
    // For example, if you are simulating without the actual sky130_fd_sc_hd library,
    // you can comment this out or replace it with a dummy module.
    
    // sky130_fd_sc_hd__tapvpwrvgnd dut (.VPWR(VPWR_out), .VGND(VGND_out), .VPB(VPB_out), .VNB(VNB_out));

    assign VPWR_out = VPWR;
    assign VGND_out = VGND;
    assign VPB_out = VPB;
    assign VNB_out = VNB;

endmodule