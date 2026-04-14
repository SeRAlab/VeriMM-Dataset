module priority_encoder_8to3 (
    input [7:0] in,
    output reg [2:0] out,
    output reg valid
);

always @(*) begin
    casez (in)
        8'b1???????: out = 3'd7; // Input 7
        8'b01??????: out = 3'd6; // Input 6
        8'b001?????: out = 3'd5; // Input 5
        8'b0001????: out = 3'd4; // Input 4
        8'b00001???: out = 3'd3; // Input 3
        8'b000001??: out = 3'd2; // Input 2
        8'b0000001?: out = 3'd1; // Input 1
        8'b00000001: out = 3'd0; // Input 0
        default:     out = 3'b000; // No valid input
    endcase
    valid = |in; // Set valid if any input is high
end

endmodule