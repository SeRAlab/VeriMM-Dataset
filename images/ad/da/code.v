module top_module();// Inputs are registered
    reg D;
    reg NOTIFIER;
    reg VPWR;
    reg VGND;

    // Outputs are wires
    wire Q;

    initial
    begin
        // Initial state is x for all inputs.
        D        = 1'bX;
        NOTIFIER = 1'bX;
        VGND     = 1'bX;
        VPWR     = 1'bX;

        #20   D        = 1'b0;
        #40   NOTIFIER = 1'b0;
        #60   VGND     = 1'b0;
        #80   VPWR     = 1'b0;
        #100  D        = 1'b1;
        #120  NOTIFIER = 1'b1;
        #140  VGND     = 1'b1;
        #160  VPWR     = 1'b1;
        #180  D        = 1'b0;
        #200  NOTIFIER = 1'b0;
        #220  VGND     = 1'b0;
        #240  VPWR     = 1'b0;
        #260  VPWR     = 1'b1;
        #280  VGND     = 1'b1;
        #300  NOTIFIER = 1'b1;
        #320  D        = 1'b1;
        #340  VPWR     = 1'bx;
        #360  VGND     = 1'bx;
        #380  NOTIFIER = 1'bx;
        #400  D        = 1'bx;
    end

    // Create a clock
    reg CLK;
    initial
    begin
        CLK = 1'b0;
    end

    always
    begin
        #5 CLK = ~CLK;
    end

    // Replace the missing module with a simple D flip-flop implementation
    reg dff_Q;
    always @(posedge CLK or posedge NOTIFIER)
    begin
        if (NOTIFIER)
            dff_Q <= 1'b0; // reset state
        else if (VPWR && !VGND)
            dff_Q <= D;
    end

    assign Q = dff_Q;

endmodule