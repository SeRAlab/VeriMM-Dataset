module hamming_encoder (
    input [7:0] data,
    output [11:0] encoded
);
    wire p1, p2, p3, p4;
    
    assign p1 = data[0] ^ data[1] ^ data[3] ^ data[4] ^ data[6];
    assign p2 = data[0] ^ data[1] ^ data[2] ^ data[3] ^ data[5] ^ data[6];
    assign p3 = data[0] ^ data[2] ^ data[3] ^ data[4] ^ data[5] ^ data[7];
    assign p4 = data[1] ^ data[2] ^ data[3] ^ data[4] ^ data[5] ^ data[7];

    assign encoded = {p4, p3, data[7:4], p2, p1, data[3:0]};
endmodule