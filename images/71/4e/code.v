module top_module(
    Z   ,
    D   ,
    S   ,
    VPWR,
    VGND,
    VPB ,
    VNB
);output       Z   ;
    input  [3:0] D   ;
    input  [3:0] S   ;
    input        VPWR;
    input        VGND;
    input        VPB ;
    input        VNB ;

    reg [3:0] Z_reg;

    always @(*) begin
        case(S)
            4'b0000: Z_reg = D[0];
            4'b0001: Z_reg = D[1];
            4'b0010: Z_reg = D[2];
            4'b0011: Z_reg = D[3];
            default: Z_reg = 4'bxxxx;
        endcase
    end

    assign Z = Z_reg;

endmodule