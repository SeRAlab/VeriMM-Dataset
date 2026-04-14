module qam_encoder (
    input [3:0] data,
    output reg signed [3:0] I,
    output reg signed [3:0] Q
);
    always @(*) begin
        case (data)
            4'b0000: begin I = -3; Q = -3; end
            4'b0001: begin I = -3; Q = -1; end
            4'b0010: begin I = -3; Q = 1; end
            4'b0011: begin I = -3; Q = 3; end
            4'b0100: begin I = -1; Q = -3; end
            4'b0101: begin I = -1; Q = -1; end
            4'b0110: begin I = -1; Q = 1; end
            4'b0111: begin I = -1; Q = 3; end
            4'b1000: begin I = 1; Q = -3; end
            4'b1001: begin I = 1; Q = -1; end
            4'b1010: begin I = 1; Q = 1; end
            4'b1011: begin I = 1; Q = 3; end
            4'b1100: begin I = 3; Q = -3; end
            4'b1101: begin I = 3; Q = -1; end
            4'b1110: begin I = 3; Q = 1; end
            4'b1111: begin I = 3; Q = 3; end
            default: begin I = 0; Q = 0; end
        endcase
    end
endmodule