module encoder_8to3 (
    input [7:0] in,
    output reg [2:0] out,
    output reg valid
);

always @(*) begin
    case (in)
        8'b00000001: {valid, out} = {1'b1, 3'b000}; // input 0
        8'b00000010: {valid, out} = {1'b1, 3'b001}; // input 1
        8'b00000100: {valid, out} = {1'b1, 3'b010}; // input 2
        8'b00001000: {valid, out} = {1'b1, 3'b011}; // input 3
        8'b00010000: {valid, out} = {1'b1, 3'b100}; // input 4
        8'b00100000: {valid, out} = {1'b1, 3'b101}; // input 5
        8'b01000000: {valid, out} = {1'b1, 3'b110}; // input 6
        8'b10000000: {valid, out} = {1'b1, 3'b111}; // input 7
        default: {valid, out} = {1'b0, 3'bxxx};      // invalid input
    endcase
end

endmodule