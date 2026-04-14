module qam_modulator (
    input [3:0] data_in,
    output reg signed [7:0] I_out,
    output reg signed [7:0] Q_out
);
    always @(*) begin
        case(data_in)
            4'b0000: begin I_out =  3;  Q_out =  3; end // 00
            4'b0001: begin I_out =  3;  Q_out =  1; end // 01
            4'b0010: begin I_out =  3;  Q_out = -1; end // 02
            4'b0011: begin I_out =  3;  Q_out = -3; end // 03
            4'b0100: begin I_out =  1;  Q_out =  3; end // 04
            4'b0101: begin I_out =  1;  Q_out =  1; end // 05
            4'b0110: begin I_out =  1;  Q_out = -1; end // 06
            4'b0111: begin I_out =  1;  Q_out = -3; end // 07
            4'b1000: begin I_out = -1;  Q_out =  3; end // 08
            4'b1001: begin I_out = -1;  Q_out =  1; end // 09
            4'b1010: begin I_out = -1;  Q_out = -1; end // 10
            4'b1011: begin I_out = -1;  Q_out = -3; end // 11
            4'b1100: begin I_out = -3;  Q_out =  3; end // 12
            4'b1101: begin I_out = -3;  Q_out =  1; end // 13
            4'b1110: begin I_out = -3;  Q_out = -1; end // 14
            4'b1111: begin I_out = -3;  Q_out = -3; end // 15
            default: begin I_out = 0; Q_out = 0; end
        endcase
    end
endmodule