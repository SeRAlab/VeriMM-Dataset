module encoder_8_to_3 (
    input wire [7:0] in,
    output reg [2:0] out
);

always @(*) begin
    casez (in)
        8'b1??????? : out = 3'b111; // input 7 is high
        8'b01?????? : out = 3'b110; // input 6 is high
        8'b001????? : out = 3'b101; // input 5 is high
        8'b0001???? : out = 3'b100; // input 4 is high
        8'b00001??? : out = 3'b011; // input 3 is high
        8'b000001?? : out = 3'b010; // input 2 is high
        8'b0000001? : out = 3'b001; // input 1 is high
        8'b00000001 : out = 3'b000; // input 0 is high
        default     : out = 3'b111; // no valid input
    endcase
end
endmodule