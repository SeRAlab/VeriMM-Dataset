module DVFS_Controller(
    input [3:0] temp_in,
    output reg [2:0] freq_out,
    output reg [1:0] volt_out,
    input clk,
    input rst
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        freq_out <= 3'b000;
        volt_out <= 2'b00;
    end else begin
        case (temp_in)
            4'b0000: begin // Temp 0-15
                freq_out <= 3'b000; // Low Frequency
                volt_out <= 2'b00; // Low Voltage
            end
            4'b0001, 4'b0010: begin // Temp 16-23
                freq_out <= 3'b001; // Medium Frequency
                volt_out <= 2'b01; // Medium Voltage
            end
            4'b0011, 4'b0100: begin // Temp 24-31
                freq_out <= 3'b010; // High Frequency
                volt_out <= 2'b10; // High Voltage
            end
            default: begin // Temp > 31
                freq_out <= 3'b111; // Max Frequency
                volt_out <= 2'b11; // Max Voltage
            end
        endcase
    end
end

endmodule