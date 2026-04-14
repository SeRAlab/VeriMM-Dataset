module top_module(
    Q    ,
    CLK  ,
    D    ,
    SET_B,
    VPWR ,
    VGND ,
    VPB  ,
    VNB
);output Q;
    input CLK;
    input D;
    input SET_B;
    input VPWR;
    input VGND;
    input VPB;
    input VNB;

    reg Q;

    always @(posedge CLK) begin
        if (!SET_B) begin
            Q <= 1'b0;
        end else begin
            Q <= D;
        end
    end

endmodule