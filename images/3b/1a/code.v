module qam_modulator (
    input clk,
    input rst,
    input [3:0] data_in,
    output reg [3:0] I_out,
    output reg [3:0] Q_out
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            I_out <= 4'b0000;
            Q_out <= 4'b0000;
        end else begin
            case (data_in)
                4'b0000: begin I_out <= 4'b0000; Q_out <= 4'b0000; end // 0
                4'b0001: begin I_out <= 4'b0001; Q_out <= 4'b0000; end // 1
                4'b0010: begin I_out <= 4'b0000; Q_out <= 4'b0001; end // 2
                4'b0011: begin I_out <= 4'b0001; Q_out <= 4'b0001; end // 3
                4'b0100: begin I_out <= 4'b0000; Q_out <= 4'b0010; end // 4
                4'b0101: begin I_out <= 4'b0001; Q_out <= 4'b0010; end // 5
                4'b0110: begin I_out <= 4'b0000; Q_out <= 4'b0011; end // 6
                4'b0111: begin I_out <= 4'b0001; Q_out <= 4'b0011; end // 7
                4'b1000: begin I_out <= 4'b0010; Q_out <= 4'b0000; end // 8
                4'b1001: begin I_out <= 4'b0011; Q_out <= 4'b0000; end // 9
                4'b1010: begin I_out <= 4'b0010; Q_out <= 4'b0001; end // A
                4'b1011: begin I_out <= 4'b0011; Q_out <= 4'b0001; end // B
                4'b1100: begin I_out <= 4'b0010; Q_out <= 4'b0010; end // C
                4'b1101: begin I_out <= 4'b0011; Q_out <= 4'b0010; end // D
                4'b1110: begin I_out <= 4'b0010; Q_out <= 4'b0011; end // E
                4'b1111: begin I_out <= 4'b0011; Q_out <= 4'b0011; end // F
                default: begin I_out <= 4'b0000; Q_out <= 4'b0000; end
            endcase
        end
    end
endmodule