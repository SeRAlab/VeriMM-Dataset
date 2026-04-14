module decoder_2to4 (
    input wire A1,
    input wire A0,
    output wire Y0,
    output wire Y1,
    output wire Y2,
    output wire Y3
);
    assign Y0 = ~A1 & ~A0; // Output Y0 is high when A1 A0 = 00
    assign Y1 = ~A1 &  A0; // Output Y1 is high when A1 A0 = 01
    assign Y2 =  A1 & ~A0; // Output Y2 is high when A1 A0 = 10
    assign Y3 =  A1 &  A0; // Output Y3 is high when A1 A0 = 11
endmodule