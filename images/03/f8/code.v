module dvfs_controller (
    input wire [1:0] workload,
    output reg [1:0] frequency
);

always @(workload) begin
    case (workload)
        2'b00: frequency = 2'b00; // Low workload -> Low frequency
        2'b01: frequency = 2'b01; // Medium workload -> Medium frequency
        2'b10: frequency = 2'b10; // High workload -> High frequency
        2'b11: frequency = 2'b11; // Very high workload -> Very high frequency
        default: frequency = 2'b00; // Default case to low frequency
    endcase
end

endmodule