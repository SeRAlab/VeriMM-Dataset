module encoder_4to2 (
    input wire [3:0] in,
    input wire enable,
    output reg [1:0] out
);

always @(*) begin
    if (!enable) begin
        out = 2'b00; // No input active, output should be '00'
    end else begin
        case (in)
            4'b0000: out = 2'b11; // No active input, output '11'
            4'b0001: out = 2'b00; // Input 0 active
            4'b0010: out = 2'b01; // Input 1 active
            4'b0100: out = 2'b10; // Input 2 active
            4'b1000: out = 2'b11; // Input 3 active
            default: out = 2'b11; // Invalid input case
        endcase
    end
end

endmodule