module VCO (
    input wire [2:0] control,
    output reg clk_out
);
    reg [22:0] counter; // Counter for frequency division

    always @(posedge clk_out) begin
        case (control)
            3'b000: counter <= counter + 1; // 1 Hz
            3'b001: counter <= counter + 2; // 2 Hz
            3'b010: counter <= counter + 4; // 4 Hz
            3'b011: counter <= counter + 8; // 8 Hz
            3'b100: counter <= counter + 16; // 16 Hz
            3'b101: counter <= counter + 32; // 32 Hz
            3'b110: counter <= counter + 64; // 64 Hz
            3'b111: counter <= counter + 128; // 128 Hz
            default: counter <= counter; // Default case
        endcase
        clk_out <= (counter == 0) ? ~clk_out : clk_out; // Toggle output on counter overflow
    end
endmodule