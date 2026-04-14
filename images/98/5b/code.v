module top_module(
    input wire clk,
    output reg Y
);// Inputs are registered
    reg A_N;
    reg B;
    reg VPWR;
    reg VGND;
    reg VPB;
    reg VNB;

    // Outputs are wires
    wire nand_out;

    // Simple NAND gate implementation (replace with actual sky130 module)
    assign nand_out = ~(A_N & B);  // Simple NAND logic

    // Connect nand output to Y
    always @(posedge clk) begin
        Y <= ~nand_out;
    end

    // Initial state is x for all inputs.
    initial begin
        A_N  = 1'bX;
        B    = 1'bX;
        VGND = 1'bX;
        VNB  = 1'bX;
        VPB  = 1'bX;
        VPWR = 1'bX;

        #20   A_N  = 1'b0;
        #40   B    = 1'b0;
        #60   VGND = 1'b0;
        #80   VNB  = 1'b0;
        #100  VPB  = 1'b0;
        #120  VPWR = 1'b0;
        #140  A_N  = 1'b1;
        #160  B    = 1'b1;
        #180  VGND = 1'b1;
        #200  VNB  = 1'b1;
        #220  VPB  = 1'b1;
        #240  VPWR = 1'b1;
        #260  A_N  = 1'b0;
        #280  B    = 1'b0;
        #300  VGND = 1'b0;
        #320  VNB  = 1'b0;
        #340  VPB  = 1'b0;
        #360  VPWR = 1'b0;
        #380  VPWR = 1'b1;
        #400  VPB  = 1'b1;
        #420  VNB  = 1'b1;
        #440  VGND = 1'b1;
        #460  B    = 1'b1;
        #480  A_N  = 1'b1;
        #500  VPWR = 1'bx;
        #520  VPB  = 1'bx;
        #540  VNB  = 1'bx;
        #560  VGND = 1'bx;
        #580  B    = 1'bx;
        #600  A_N  = 1'bx;
    end

endmodule