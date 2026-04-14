module top_module(
    input  wire        A_N,
    input  wire        B,
    input  wire        C,
    input  wire        VPWR,
    input  wire        VGND,
    input  wire        VPB,
    input  wire        VNB,
    output reg         X
);// AND gate implementation
    always @(*) begin
        if (A_N == 1'b1 && B == 1'b1 && C == 1'b1) begin
            X <= 1'b1;
        end
        else begin
            X <= 1'b0;
        end
    end

endmodule