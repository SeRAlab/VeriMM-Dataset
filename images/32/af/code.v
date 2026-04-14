module encoder32to5(
    input [31:0] in,
    output reg [4:0] out
);
    always @(*) begin
        case (1'b1)
            in[0]: out = 5'd0;
            in[1]: out = 5'd1;
            in[2]: out = 5'd2;
            in[3]: out = 5'd3;
            in[4]: out = 5'd4;
            in[5]: out = 5'd5;
            in[6]: out = 5'd6;
            in[7]: out = 5'd7;
            in[8]: out = 5'd8;
            in[9]: out = 5'd9;
            in[10]: out = 5'd10;
            in[11]: out = 5'd11;
            in[12]: out = 5'd12;
            in[13]: out = 5'd13;
            in[14]: out = 5'd14;
            in[15]: out = 5'd15;
            in[16]: out = 5'd16;
            in[17]: out = 5'd17;
            in[18]: out = 5'd18;
            in[19]: out = 5'd19;
            in[20]: out = 5'd20;
            in[21]: out = 5'd21;
            in[22]: out = 5'd22;
            in[23]: out = 5'd23;
            in[24]: out = 5'd24;
            in[25]: out = 5'd25;
            in[26]: out = 5'd26;
            in[27]: out = 5'd27;
            in[28]: out = 5'd28;
            in[29]: out = 5'd29;
            in[30]: out = 5'd30;
            in[31]: out = 5'd31;
            default: out = 5'd0;
        endcase
    end
endmodule