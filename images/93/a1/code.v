module top_module(
    input D,
    input RESET_B,
    input GATE,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output reg Q
);always @ (posedge GATE or negedge RESET_B) begin
        if (!RESET_B)
            Q <= 1'b0;
        else
            Q <= D;
    end

endmodule