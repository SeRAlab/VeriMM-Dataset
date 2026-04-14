module top_module( 
    input [255:0] in,
    input [7:0] sel,
    output out );wire [127:0] out_128;
    wire [63:0] out_64;
    wire [31:0] out_32;
    wire [15:0] out_16;
    wire [7:0] out_8;
    wire [3:0] out_4;
    wire [1:0] out_2;
    
    assign out_128 = {in[255:128], in[127:0]};
    assign out_64 = {out_128[63:32], out_128[31:0]};
    assign out_32 = {out_64[31:16], out_64[15:0]};
    assign out_16 = {out_32[15:8], out_32[7:0]};
    assign out_8 = {out_16[7:4], out_16[3:0]};
    assign out_4 = {out_8[3:2], out_8[1:0]};
    assign out_2 = {out_4[1], out_4[0]};
    
    assign out = out_2[sel[7]] & out_2[sel[6]] & out_2[sel[5]] & out_2[sel[4]] & out_2[sel[3]] & out_2[sel[2]] & out_2[sel[1]] & out_2[sel[0]];
    
endmodule