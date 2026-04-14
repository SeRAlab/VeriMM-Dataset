module DVFS_Controller (
    input wire [2:0] workload, // 3-bit workload input
    input wire enable,          // 1-bit control signal
    output reg [1:0] frequency, // 2-bit frequency output (00: low, 01: medium, 10: high)
    output reg [1:0] voltage    // 2-bit voltage output (00: low, 01: medium, 10: high)
);

always @(workload or enable) begin
    if (enable) begin
        case (workload)
            3'b000: begin // low workload
                frequency = 2'b00; // low frequency
                voltage = 2'b00;   // low voltage
            end
            3'b001: begin // medium workload
                frequency = 2'b01; // medium frequency
                voltage = 2'b01;   // medium voltage
            end
            3'b010: begin // high workload
                frequency = 2'b10; // high frequency
                voltage = 2'b10;   // high voltage
            end
            default: begin
                frequency = 2'b00; // default to low
                voltage = 2'b00;   // default to low
            end
        endcase
    end else begin
        frequency = 2'b00; // when disabled, set to low
        voltage = 2'b00;   // when disabled, set to low
    end
end

endmodule