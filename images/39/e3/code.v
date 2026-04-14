module DVFS_Controller (
    input [1:0] voltage, // 00 = 0.9V, 01 = 1.0V, 10 = 1.1V, 11 = 1.2V
    input [1:0] frequency, // 00 = 1GHz, 01 = 2GHz, 10 = 3GHz
    output reg valid
);

    always @(*) begin
        // Voltage valid levels: 00, 01, 10, 11
        // Frequency valid levels: 00, 01, 10
        if ((voltage >= 2'b00 && voltage <= 2'b11) && (frequency >= 2'b00 && frequency <= 2'b10)) begin
            valid = 1'b1; // Valid settings
        end else begin
            valid = 1'b0; // Invalid settings
        end
    end
endmodule