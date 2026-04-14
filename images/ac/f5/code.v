module top_module(
    input wire VPWR,
    input wire VGND,
    output wire tap,
    output wire tap_bar
);assign tap = (VPWR == 1'b1 && VGND == 1'b0) ? 1'b0 :
                 (VPWR == 1'bx && VGND == 1'b1) ? 1'bx :
                 (VPWR == 1'b1 && VGND == 1'bx) ? 1'bx :
                 (VPWR == 0 && VGND == 1'b1) ? 1'b1 :
                 (VPWR == 0 && VGND == 1'bx) ? 1'bx :
                 (VPWR == 1'bx && VGND == 0) ? 1'bx : 1'bx;
    
    assign tap_bar = (VPWR == 1'b1 && VGND == 1'b0) ? 1'b1 :
                     (VPWR == 1'bx && VGND == 1'b1) ? 1'bx :
                     (VPWR == 1'b1 && VGND == 1'bx) ? 1'bx :
                     (VPWR == 0 && VGND == 1'b1) ? 1'b0 :
                     (VPWR == 0 && VGND == 1'bx) ? 1'bx :
                     (VPWR == 1'bx && VGND == 0) ? 1'bx : 1'bx;

endmodule