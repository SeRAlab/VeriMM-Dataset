module DVFS_Controller(
    input wire [2:0] load,
    input wire enable,
    output reg [1:0] frequency
);
    always @(load or enable) begin
        if (enable) begin
            case (load)
                3'b000, 3'b001, 3'b010, 3'b011: frequency = 2'b00; // Low Frequency
                3'b100, 3'b101, 3'b110, 3'b111: frequency = 2'b01; // High Frequency
                default: frequency = 2'b00; // Default to Low Frequency
            endcase
        end else begin
            frequency = 2'b00; // Disable mode
        end
    end
endmodule