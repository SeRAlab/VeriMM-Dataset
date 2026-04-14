module priority_encoder (
    input [7:0] in,
    output reg [2:0] out,
    output reg valid
);
    always @(*) begin
        casez (in)
            8'b1xxxxxxx: begin out = 3'b111; valid = 1; end // Input 7
            8'b01xxxxxx: begin out = 3'b110; valid = 1; end // Input 6
            8'b001xxxxx: begin out = 3'b101; valid = 1; end // Input 5
            8'b0001xxxx: begin out = 3'b100; valid = 1; end // Input 4
            8'b00001xxx: begin out = 3'b011; valid = 1; end // Input 3
            8'b000001xx: begin out = 3'b010; valid = 1; end // Input 2
            8'b0000001x: begin out = 3'b001; valid = 1; end // Input 1
            8'b00000001: begin out = 3'b000; valid = 1; end // Input 0
            default: begin out = 3'bxxx; valid = 0; end // No input
        endcase
    end
endmodule