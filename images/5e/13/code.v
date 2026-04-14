module top_module(
    input wire VPWR,
    output reg VGND,
    output reg VPB,
    output reg VNB
);always @(*) begin
        if(VPWR == 1'b1) begin
            VGND = 1'b0;
            VPB = 1'b1;
            VNB = 1'b0;
        end else begin
            VGND = 1'b1;
            VPB = 1'b0;
            VNB = 1'b1;
        end
    end

endmodule