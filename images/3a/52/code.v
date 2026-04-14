module QAM_modulator (
    input wire clk,
    input wire [3:0] data_in,
    output reg [3:0] I_out,
    output reg [3:0] Q_out
);
    always @(posedge clk) begin
        case (data_in)
            4'b0000: begin I_out <= 4'b0000; Q_out <= 4'b0000; end // 0
            4'b0001: begin I_out <= 4'b0001; Q_out <= 4'b0000; end // 1
            4'b0010: begin I_out <= 4'b0000; Q_out <= 4'b0001; end // 2
            4'b0011: begin I_out <= 4'b0001; Q_out <= 4'b0001; end // 3
            4'b0100: begin I_out <= 4'b0010; Q_out <= 4'b0000; end // 4
            4'b0101: begin I_out <= 4'b0011; Q_out <= 4'b0000; end // 5
            4'b0110: begin I_out <= 4'b0010; Q_out <= 4'b0001; end // 6
            4'b0111: begin I_out <= 4'b0011; Q_out <= 4'b0001; end // 7
            4'b1000: begin I_out <= 4'b0000; Q_out <= 4'b0010; end // 8
            4'b1001: begin I_out <= 4'b0001; Q_out <= 4'b0010; end // 9
            4'b1010: begin I_out <= 4'b0000; Q_out <= 4'b0011; end // 10
            4'b1011: begin I_out <= 4'b0001; Q_out <= 4'b0011; end // 11
            4'b1100: begin I_out <= 4'b0010; Q_out <= 4'b0010; end // 12
            4'b1101: begin I_out <= 4'b0011; Q_out <= 4'b0010; end // 13
            4'b1110: begin I_out <= 4'b0010; Q_out <= 4'b0011; end // 14
            4'b1111: begin I_out <= 4'b0011; Q_out <= 4'b0011; end // 15
            default: begin I_out <= 4'bxxxx; Q_out <= 4'bxxxx; end
        endcase
    end
endmodule