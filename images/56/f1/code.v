module top_module(
    VPWR,
    VGND,
    VDDVGND
);input VPWR;
    input VGND;
    output reg VDDVGND;

    always @(*) begin
        VDDVGND = VPWR - VGND;
    end

endmodule