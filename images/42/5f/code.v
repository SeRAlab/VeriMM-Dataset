module top_module(
    input A,
    input VGND,
    input VNB,
    input VPB,
    input VPWR,
    output wire X
);reg [4:0] state;

initial begin
    state = 5'bxxxxx;
end

always @(posedge A) begin
    case (state)
        5'bxxxx0: state <= 5'bxxx0x;
        5'bxxx0x: state <= 5'bxx0xx;
        5'bxx0xx: state <= 5'bx0xxx;
        5'b0xxxx: state <= 5'b1xxxx;
        5'b1xxxx: state <= 5'b0xxxx;
        default: state <= 5'bxxxxx;
    endcase
end

assign X = (state == 5'b00001);

endmodule