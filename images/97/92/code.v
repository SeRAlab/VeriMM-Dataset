module top_module(
    input A1,
    input A2,
    input B1_N,
    input VPWR,
    input VGND,
    output reg X
);always @(*)
begin
    if ((A1 == 1'b0) && (A2 == 1'b0) && (B1_N == 1'b1) && (VPWR == 1'b1) && (VGND != 1'bx))
        X = 1'b1;
    else if ((A1 == 1'b1) && (A2 == 1'b1) && (B1_N == 1'b0) && (VPWR == 1'b0) && (VGND != 1'bx))
        X = 1'b1;
    else
        X = 1'b0;
end

endmodule