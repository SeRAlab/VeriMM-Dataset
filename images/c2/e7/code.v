module bcd_converter (
    input [3:0] in,
    output reg [3:0] out,
    output invalid
);

always @(*) begin
    case (in)
        4'b0000: out = 4'b0000;
        4'b0001: out = 4'b0001;
        4'b0010: out = 4'b0010;
        4'b0011: out = 4'b0011;
        4'b0100: out = 4'b0100;
        4'b0101: out = 4'b0101;
        4'b0110: out = 4'b0110;
        4'b0111: out = 4'b0111;
        4'b1000: out = 4'b1000;
        4'b1001: out = 4'b1001;
        default: begin
            out = 4'bxxxx;
            invalid = 1;
        end
    endcase
end

endmodule