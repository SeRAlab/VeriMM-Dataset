module top_module(
    input DIODE,
    input VPWR,
    input VGND,
    output reg RECTIFIED_SIGNAL
);wire VPB;
    wire VNB;
    assign VPB = DIODE ? VPWR : VGND;
    assign VNB = DIODE ? VGND : VPWR;
    
    always @(*) begin
        RECTIFIED_SIGNAL = DIODE ? DIODE : 1'b0;
    end

endmodule