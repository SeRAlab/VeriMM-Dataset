module encoder_32to5 (
    input  [31:0] in,
    output [4:0] out
);
    assign out = (in[31]) ? 5'd31 :
                 (in[30]) ? 5'd30 :
                 (in[29]) ? 5'd29 :
                 (in[28]) ? 5'd28 :
                 (in[27]) ? 5'd27 :
                 (in[26]) ? 5'd26 :
                 (in[25]) ? 5'd25 :
                 (in[24]) ? 5'd24 :
                 (in[23]) ? 5'd23 :
                 (in[22]) ? 5'd22 :
                 (in[21]) ? 5'd21 :
                 (in[20]) ? 5'd20 :
                 (in[19]) ? 5'd19 :
                 (in[18]) ? 5'd18 :
                 (in[17]) ? 5'd17 :
                 (in[16]) ? 5'd16 :
                 (in[15]) ? 5'd15 :
                 (in[14]) ? 5'd14 :
                 (in[13]) ? 5'd13 :
                 (in[12]) ? 5'd12 :
                 (in[11]) ? 5'd11 :
                 (in[10]) ? 5'd10 :
                 (in[9])  ? 5'd9  :
                 (in[8])  ? 5'd8  :
                 (in[7])  ? 5'd7  :
                 (in[6])  ? 5'd6  :
                 (in[5])  ? 5'd5  :
                 (in[4])  ? 5'd4  :
                 (in[3])  ? 5'd3  :
                 (in[2])  ? 5'd2  :
                 (in[1])  ? 5'd1  :
                 (in[0])  ? 5'd0  :
                 5'd0; // default output when no bits are set
endmodule