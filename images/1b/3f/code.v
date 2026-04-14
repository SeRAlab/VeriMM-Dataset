module vco (
    input clk,
    input [3:0] control_voltage,
    output reg vco_out
);
    reg [31:0] counter;
    reg [31:0] frequency;

    always @(posedge clk) begin
        // Mapping control_voltage to frequency
        case(control_voltage)
            4'b0000: frequency <= 32'd50000000; // 1 Hz assuming 50MHz clock
            4'b0001: frequency <= 32'd25000000; // 2 Hz
            4'b0010: frequency <= 32'd12500000; // 4 Hz
            4'b0011: frequency <= 32'd6250000;  // 8 Hz
            4'b0100: frequency <= 32'd3125000;  // 16 Hz
            4'b0101: frequency <= 32'd1562500;  // 32 Hz
            4'b0110: frequency <= 32'd781250;   // 64 Hz
            4'b0111: frequency <= 32'd390625;   // 128 Hz
            4'b1000: frequency <= 32'd195312;   // 256 Hz
            4'b1001: frequency <= 32'd97656;    // 512 Hz
            4'b1010: frequency <= 32'd48828;    // 1 kHz
            4'b1011: frequency <= 32'd24414;    // 2 kHz
            4'b1100: frequency <= 32'd12207;    // 4 kHz
            4'b1101: frequency <= 32'd6103;     // 8 kHz
            4'b1110: frequency <= 32'd3051;     // 16 kHz
            4'b1111: frequency <= 32'd1525;     // 32 kHz
            default: frequency <= 32'd50000000; // Default to 1 Hz
        endcase

        // Increment counter
        counter <= counter + 1;

        // Toggle output based on frequency
        if (counter >= frequency) begin
            vco_out <= ~vco_out;
            counter <= 0;
        end
    end
endmodule