module top_module(
    output reg X,  // Changed from wire to reg
    input A0,
    input A1,
    input A2,
    input A3,
    input S0,
    input S1,
    input VPWR,
    input VGND,
    input VPB,
    input VNB
);reg [3:0] A;
    reg [1:0] S;

    always @(*) begin
        A[0] = A0;
        A[1] = A1;
        A[2] = A2;
        A[3] = A3;

        S[0] = S0;
        S[1] = S1;

        case (S)
            2'b00: X = A[0];
            2'b01: X = A[1];
            2'b10: X = A[2];
            2'b11: X = A[3];
        endcase
    end

endmodule