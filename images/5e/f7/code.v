module decoder_4to16(A, E, D);
    input [3:0] A;
    input E;
    output [15:0] D;
    
    wire [3:0] nA;
    wire [15:0] temp;

    not (nA[0], A[0]);
    not (nA[1], A[1]);
    not (nA[2], A[2]);
    not (nA[3], A[3]);
    
    and (temp[0], nA[3], nA[2], nA[1], nA[0]);
    and (temp[1], nA[3], nA[2], nA[1], A[0]);
    and (temp[2], nA[3], nA[2], A[1], nA[0]);
    and (temp[3], nA[3], nA[2], A[1], A[0]);
    and (temp[4], nA[3], A[2], nA[1], nA[0]);
    and (temp[5], nA[3], A[2], nA[1], A[0]);
    and (temp[6], nA[3], A[2], A[1], nA[0]);
    and (temp[7], nA[3], A[2], A[1], A[0]);
    and (temp[8], A[3], nA[2], nA[1], nA[0]);
    and (temp[9], A[3], nA[2], nA[1], A[0]);
    and (temp[10], A[3], nA[2], A[1], nA[0]);
    and (temp[11], A[3], nA[2], A[1], A[0]);
    and (temp[12], A[3], A[2], nA[1], nA[0]);
    and (temp[13], A[3], A[2], nA[1], A[0]);
    and (temp[14], A[3], A[2], A[1], nA[0]);
    and (temp[15], A[3], A[2], A[1], A[0]);

    assign D = E ? temp : 16'b0;
endmodule