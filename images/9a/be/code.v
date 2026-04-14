module top_module(
    input D,
    output Q,
    input CLK,
    input DE,
    input SCD,
    input SCE,
    input VPB,
    input VPWR,
    input VGND,
    input VNB
);reg q;

    always @(posedge CLK) begin
        if (DE) begin
            q <= D;
        end
    end

    assign Q = q;

endmodule