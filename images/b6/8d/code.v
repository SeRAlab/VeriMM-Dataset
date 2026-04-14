module top_module(
    input VPB,
    input VPWR,
    input VGND,
    input VNB,
    output reg VCC,
    output reg VDD
);always @(*) begin
    if (VPB == 1'b0) begin
        VCC = 1'b0;
        VDD = 1'b0;
    end else if (VPWR == 1'b1) begin
        VCC = 1'b1;
        VDD = 1'b0;
    end else if (VNB == 1'b1) begin
        VCC = 1'b0;
        VDD = 1'b1;
    end else begin
        VCC = 1'b0;
        VDD = 1'b0;
    end
end

endmodule