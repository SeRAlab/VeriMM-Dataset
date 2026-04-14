module top_module(input VPWR, input VGND, output decap);assign decap = (VPWR == 1'b0) && (VGND == 1'b1) ? 1'b1 : 1'b0;

endmodule