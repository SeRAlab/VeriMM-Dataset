module dvfs_controller(
    input [2:0] load,
    output reg [1:0] frequency
);
    
    always @(*) begin
        case (load)
            3'b000: frequency = 2'b00; // Low Frequency
            3'b001: frequency = 2'b00; // Low Frequency
            3'b010: frequency = 2'b01; // Medium Frequency
            3'b011: frequency = 2'b01; // Medium Frequency
            3'b100: frequency = 2'b10; // High Frequency
            3'b101: frequency = 2'b10; // High Frequency
            3'b110: frequency = 2'b10; // High Frequency
            3'b111: frequency = 2'b10; // High Frequency
            default: frequency = 2'b00; // Default case
        endcase
    end
endmodule