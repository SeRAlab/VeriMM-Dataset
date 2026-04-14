module dvfs_controller(
    input wire clk,
    input wire rst,
    input wire [1:0] freq_vol_input, // 2-bit input representing desired frequency and voltage
    output reg [1:0] state // 2-bit output representing the selected operational state
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 2'b00; // Reset state
    end else begin
        case (freq_vol_input)
            2'b00: state <= 2'b00; // Low Frequency/Low Voltage
            2'b01: state <= 2'b01; // Low Frequency/High Voltage
            2'b10: state <= 2'b10; // High Frequency/Low Voltage
            2'b11: state <= 2'b11; // High Frequency/High Voltage
            default: state <= 2'b00; // Default to Reset state
        endcase
    end
end

endmodule