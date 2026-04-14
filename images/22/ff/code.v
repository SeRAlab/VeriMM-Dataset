module encoder_4to2 (
    input wire [3:0] in,     // 4 input lines
    input wire enable,       // Enable signal
    output reg [1:0] out     // 2 output lines
);

always @(*) begin
    if (!enable) begin
        out = 2'b00; // Default output when enable is low
    end else begin
        case (in)
            4'b0001: out = 2'b00; // Input 0
            4'b0010: out = 2'b01; // Input 1
            4'b0100: out = 2'b10; // Input 2
            4'b1000: out = 2'b11; // Input 3
            default: out = 2'b00;  // If none are active, default to 00
        endcase
    end
end

endmodule