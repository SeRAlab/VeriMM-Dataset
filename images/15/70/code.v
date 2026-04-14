module DVFS_Controller (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [3:0] temperature,
    output reg [2:0] frequency
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            frequency <= 3'b000; // Default to low frequency
        end else if (enable) begin
            case (temperature)
                4'b0000: frequency <= 3'b000; // Low frequency
                4'b0001: frequency <= 3'b001; // Medium frequency
                4'b0010: frequency <= 3'b010; // High frequency
                default: frequency <= 3'b011;  // Max frequency
            endcase
        end
    end
endmodule