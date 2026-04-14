module qam_mapper (
    input [3:0] symbol,
    output reg [2:0] I,
    output reg [2:0] Q
);
    always @(*) begin
        case(symbol)
            4'b0000: begin I = 3'b000; Q = 3'b000; end
            4'b0001: begin I = 3'b000; Q = 3'b001; end
            4'b0010: begin I = 3'b001; Q = 3'b000; end
            4'b0011: begin I = 3'b001; Q = 3'b001; end
            4'b0100: begin I = 3'b010; Q = 3'b000; end
            4'b0101: begin I = 3'b010; Q = 3'b001; end
            4'b0110: begin I = 3'b011; Q = 3'b000; end
            4'b0111: begin I = 3'b011; Q = 3'b001; end
            4'b1000: begin I = 3'b100; Q = 3'b000; end
            4'b1001: begin I = 3'b100; Q = 3'b001; end
            4'b1010: begin I = 3'b101; Q = 3'b000; end
            4'b1011: begin I = 3'b101; Q = 3'b001; end
            4'b1100: begin I = 3'b110; Q = 3'b000; end
            4'b1101: begin I = 3'b110; Q = 3'b001; end
            4'b1110: begin I = 3'b111; Q = 3'b000; end
            4'b1111: begin I = 3'b111; Q = 3'b001; end
            default: begin I = 3'bxxx; Q = 3'bxxx; end
        endcase
    end
endmodule