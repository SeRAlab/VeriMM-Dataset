module top_module( input logic a,b,
                input logic subres,
                output logic [31:0] r);assign r ={{31{1'b0}}, (~(a^b) & subres) | (a & ~b)};endmodule