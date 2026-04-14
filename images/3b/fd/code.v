module decoder_2_to_4 (
    input wire A1,
    input wire A0,
    output reg [3:0] Y
);

always @(*) begin
    case ({A1, A0})
        2'b00: Y = 4'b0001; // Y0 is high
        2'b01: Y = 4'b0010; // Y1 is high
        2'b10: Y = 4'b0100; // Y2 is high
        2'b11: Y = 4'b1000; // Y3 is high
        default: Y = 4'b0000; // Default case
    endcase
end

endmodule