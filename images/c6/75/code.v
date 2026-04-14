module supply_signals (
    input wire clk,
    output reg VPWR,
    output reg VGND,
    output reg VPB,
    output reg VNB
);

    always @(posedge clk) begin
        VPWR <= 1;
        VGND <= 0;
        VPB <= 1;
        VNB <= 0;
    end

endmodule