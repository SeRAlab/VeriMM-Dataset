module decoder_2to4 (
    input wire A1,
    input wire A0,
    output wire Y3,
    output wire Y2,
    output wire Y1,
    output wire Y0
);
assign Y0 = ~A1 & ~A0; // 00
assign Y1 = ~A1 & A0;  // 01
assign Y2 = A1 & ~A0;  // 10
assign Y3 = A1 & A0;   // 11
endmodule