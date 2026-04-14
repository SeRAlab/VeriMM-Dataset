module vco(
    input clk,
    input reset,
    input [1:0] ctrl_voltage, // 00 for low frequency, 01 for medium frequency, 10 for high frequency
    output reg freq_out
);
    reg [1:0] state;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00; // Reset to low frequency
        end else begin
            case (ctrl_voltage)
                2'b00: state <= 2'b00; // Low frequency
                2'b01: state <= 2'b01; // Medium frequency
                2'b10: state <= 2'b10; // High frequency
                default: state <= 2'b00; // Default to low frequency
            endcase
        end
    end

    always @(posedge clk) begin
        if (state == 2'b00) begin
            freq_out <= ~freq_out; // Toggle frequency output for low
        end else if (state == 2'b01) begin
            freq_out <= freq_out; // Keep output the same for medium
        end else if (state == 2'b10) begin
            freq_out <= ~freq_out; // Toggle frequency output for high
        end
    end
endmodule