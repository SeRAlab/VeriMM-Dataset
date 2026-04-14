module top_module(
    input  A,
    output reg Z,  // Change the output to reg type
    input  TE,
    input  VPB,
    input  VPWR,
    input  VGND,
    input  VNB
);wire inv_A;

    assign inv_A = ~A;

    always @ (posedge TE) begin
        Z <= inv_A;  // Z can now be assigned since it's a reg type
    end

endmodule