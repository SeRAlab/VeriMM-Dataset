module top_module(
    input A1,
    input A2,
    input B1,
    input C1,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output reg X  // Change output to reg type to match assignment in always block
);// Instantiate the missing module if available, or comment out if not needed
    // wire X_sky130;
    // sky130_fd_sc_ls__a211o_2 base (
    //     .X(X_sky130),
    //     .A1(A1),
    //     .A2(A2),
    //     .B1(B1),
    //     .C1(C1),
    //     .VPWR(VPWR),
    //     .VGND(VGND),
    //     .VPB(VPB),
    //     .VNB(VNB)
    // );

    always @(*) begin
        if (A1 && A2 && B1 && !C1) begin
            X <= 1;
        end else begin
            X <= 0;
        end
    end

endmodule