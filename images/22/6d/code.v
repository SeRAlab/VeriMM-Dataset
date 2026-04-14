module dvfs_controller (
    input wire [3:0] workload, // 4-bit workload input
    output reg [1:0] voltage,  // 2-bit voltage output
    output reg [1:0] frequency // 2-bit frequency output
);

always @(workload) begin
    if (workload < 4'd4) begin
        voltage <= 2'b00; // Low voltage
        frequency <= 2'b00; // Low frequency
    end else if (workload < 4'd8) begin
        voltage <= 2'b01; // Medium voltage
        frequency <= 2'b01; // Medium frequency
    end else if (workload < 4'd12) begin
        voltage <= 2'b10; // High voltage
        frequency <= 2'b10; // High frequency
    end else begin
        voltage <= 2'b11; // Max voltage
        frequency <= 2'b11; // Max frequency
    end
end

endmodule