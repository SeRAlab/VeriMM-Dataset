module matrix_inverse(
    input [8:0] a00, a01, a02,
    input [8:0] a10, a11, a12,
    input [8:0] a20, a21, a22,
    output reg [8:0] inv00, inv01, inv02,
    output reg [8:0] inv10, inv11, inv12,
    output reg [8:0] inv20, inv21, inv22
);
    wire [15:0] det;
    assign det = a00*(a11*a22 - a12*a21) - a01*(a10*a22 - a12*a20) + a02*(a10*a21 - a11*a20);

    always @(*) begin
        if (det == 0) begin
            {inv00, inv01, inv02, inv10, inv11, inv12, inv20, inv21, inv22} = 0;
        end else begin
            inv00 = (a11*a22 - a12*a21) / det;
            inv01 = (a02*a21 - a01*a22) / det;
            inv02 = (a01*a12 - a02*a11) / det;
            inv10 = (a12*a20 - a10*a22) / det;
            inv11 = (a00*a22 - a02*a20) / det;
            inv12 = (a10*a02 - a00*a12) / det;
            inv20 = (a10*a21 - a11*a20) / det;
            inv21 = (a01*a20 - a00*a21) / det;
            inv22 = (a00*a11 - a01*a10) / det;
        end
    end
endmodule