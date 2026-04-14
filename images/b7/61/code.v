module top_module(
    input [7:0] Y,
    input [7:0] Cb,
    input [7:0] Cr,
    input [7:0] Ta,
    input [7:0] Tb,
    input [7:0] Tc,
    input [7:0] Td,
    output [7:0] binary
    );assign binary = (Ta < Cb && Cb < Tb && Tc < Cr && Cr < Td) ? 8'hFF : 8'h00; 

endmodule