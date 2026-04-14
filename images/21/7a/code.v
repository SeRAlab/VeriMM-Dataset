module DVFS_Controller (
    input wire clk,
    input wire [1:0] voltage_level,
    output reg [1:0] frequency_level
);

always @(posedge clk) begin
    case (voltage_level)
        2'b00: frequency_level <= 2'b00; // Lowest frequency
        2'b01: frequency_level <= 2'b01;
        2'b10: frequency_level <= 2'b10;
        2'b11: frequency_level <= 2'b11; // Highest frequency
        default: frequency_level <= 2'b00; // Default case
    endcase
end

endmodule