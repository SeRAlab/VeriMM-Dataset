module DVFS_Controller (
    input [2:0] workload,
    input power_save_mode,
    output reg [1:0] voltage,
    output reg [1:0] frequency
);
    always @(*) begin
        if (power_save_mode) begin
            case (workload)
                3'b000: {voltage, frequency} = {2'b01, 2'b00}; // Low workload
                3'b001: {voltage, frequency} = {2'b10, 2'b01}; // Medium workload
                3'b010: {voltage, frequency} = {2'b11, 2'b10}; // High workload
                default: {voltage, frequency} = {2'b00, 2'b00}; // Default case
            endcase
        end else begin
            case (workload)
                3'b000: {voltage, frequency} = {2'b10, 2'b01}; // Low workload
                3'b001: {voltage, frequency} = {2'b11, 2'b10}; // Medium workload
                3'b010: {voltage, frequency} = {2'b11, 2'b11}; // High workload
                default: {voltage, frequency} = {2'b00, 2'b00}; // Default case
            endcase
        end
    end
endmodule