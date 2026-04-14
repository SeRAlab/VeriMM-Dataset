module qam_encoder (
    input [3:0] data_in,
    output reg [3:0] I_out,
    output reg [3:0] Q_out
);
    always @(data_in) begin
        case (data_in)
            4'b0000: begin I_out = 4'b0000; Q_out = 4'b0000; end // (0,0)
            4'b0001: begin I_out = 4'b0001; Q_out = 4'b0000; end // (1,0)
            4'b0010: begin I_out = 4'b0000; Q_out = 4'b0001; end // (0,1)
            4'b0011: begin I_out = 4'b0001; Q_out = 4'b0001; end // (1,1)
            4'b0100: begin I_out = 4'b0010; Q_out = 4'b0000; end // (2,0)
            4'b0101: begin I_out = 4'b0010; Q_out = 4'b0001; end // (2,1)
            4'b0110: begin I_out = 4'b0000; Q_out = 4'b0010; end // (0,2)
            4'b0111: begin I_out = 4'b0011; Q_out = 4'b0001; end // (3,1)
            4'b1000: begin I_out = 4'b0011; Q_out = 4'b0000; end // (3,0)
            4'b1001: begin I_out = 4'b0010; Q_out = 4'b0010; end // (2,2)
            4'b1010: begin I_out = 4'b0001; Q_out = 4'b0010; end // (1,2)
            4'b1011: begin I_out = 4'b0011; Q_out = 4'b0010; end // (3,2)
            4'b1100: begin I_out = 4'b0001; Q_out = 4'b0011; end // (1,3)
            4'b1101: begin I_out = 4'b0010; Q_out = 4'b0011; end // (2,3)
            4'b1110: begin I_out = 4'b0011; Q_out = 4'b0011; end // (3,3)
            4'b1111: begin I_out = 4'b0000; Q_out = 4'b0011; end // (0,3)
            default: begin I_out = 4'b0000; Q_out = 4'b0000; end // default case
        endcase
    end
endmodule