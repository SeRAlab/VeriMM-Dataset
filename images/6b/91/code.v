module top_module(
    input DIODE,
    input VPB,
    input VPWR,
    input VGND,
    input VNB,
    output reg OUT
);function automatic [31:0] max(input [31:0] a, input [31:0] b);
    begin
        if (a > b) 
            max = a;
        else 
            max = b;
    end
endfunction

always @(*) begin
    if (DIODE == 1) begin
        OUT = max(VPB, VPWR) - max(VGND, VNB);
    end else begin
        OUT = VPWR - max(VGND, VNB);
    end
end

endmodule