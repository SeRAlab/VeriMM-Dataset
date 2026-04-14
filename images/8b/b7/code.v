module top_module(
    input clk,
    output reg VPWR,
    output reg VGND,
    output reg VPB,
    output reg VNB
);reg [8:0] counter = 0;

always @(posedge clk) begin
    counter <= counter + 1;
    case(counter)
        20: VGND <= 0;
        40: VNB <= 0;
        60: VPB <= 0;
        80: VPWR <= 0;
        100: VGND <= 1;
        120: VNB <= 1;
        140: VPB <= 1;
        160: VPWR <= 1;
        180: VGND <= 0;
        200: VNB <= 0;
        220: VPB <= 0;
        240: VPWR <= 0;
        260: VPWR <= 1;
        280: VPB <= 1;
        300: VNB <= 1;
        320: VGND <= 1;
        340: begin
                VPWR <= 1'bx;
                VPB <= 1'bx;
                VNB <= 1'bx;
             end
        360: begin
                VPWR <= 1'bx;
                VPB <= 1'bx;
                VNB <= 1'bx;
             end
        380: begin
                VPWR <= 1'bx;
                VPB <= 1'bx;
                VNB <= 1'bx;
             end
        400: VGND <= 1'bx;
    endcase
end

endmodule