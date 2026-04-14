module priority_encoder(
    input [3:0] in,
    output reg [1:0] out
);

always @(*) begin
    casez (in)
        4'b1???: out = 2'b11; // highest priority bit at position 3
        4'b01??: out = 2'b10; // highest priority bit at position 2
        4'b001?: out = 2'b01; // highest priority bit at position 1
        4'b0001: out = 2'b00; // highest priority bit at position 0
        default: out = 2'b00; // no bits set
    endcase
end

endmodule