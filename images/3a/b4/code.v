module qam_modulator (
    input [1:0] in,
    output reg [3:0] out
);

always @(*) begin
    case (in)
        2'b00: out = 4'b0000;
        2'b01: out = 4'b0001;
        2'b10: out = 4'b0010;
        2'b11: out = 4'b0011;
        default: out = 4'bxxxx; // Undefined
    endcase
end

endmodule