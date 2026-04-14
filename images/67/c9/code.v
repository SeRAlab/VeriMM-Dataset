module top_module(
    VPWR,
    VGND,
    VPB ,
    VNB ,
    in,
    out,
    reset
);// Module ports
    input VPWR;
    input VGND;
    input VPB ;
    input VNB ;
    input [3:0] in;
    output reg [1:0] out;
    input reset;
    
    // Reset behavior
    always @ (posedge reset) begin
        out <= 2'b11;
    end
    
    // Decoder logic
    always @ (*) begin
        case (in)
            4'b0001: out <= 2'b10;
            4'b0010: out <= 2'b01;
            4'b0100: out <= 2'b00;
            4'b1000: out <= 2'b00;
            default: out <= 2'b11;
        endcase
    end

endmodule