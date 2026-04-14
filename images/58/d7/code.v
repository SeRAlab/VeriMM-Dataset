module top_module(
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output reg power_out
);always @(*) begin
    if (VPWR || VGND || VPB || VNB) begin
        power_out = 1'b1;
    end else begin
        power_out = 1'b0;
    end
end

endmodule