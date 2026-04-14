module dvfs_controller (
    input wire clk,
    input wire reset,
    input wire [7:0] temperature, // 8-bit temperature input
    output reg [1:0] voltage,     // 2-bit voltage output (00: 1V, 01: 1.8V)
    output reg [1:0] frequency    // 2-bit frequency output (00: 1GHz, 01: 2.5GHz)
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        voltage <= 2'b01;       // Default to 1.8V
        frequency <= 2'b01;     // Default to 2.5GHz
    end else begin
        if (temperature > 8'd75) begin
            voltage <= 2'b00;   // Set to 1V
            frequency <= 2'b00; // Set to 1GHz
        end else begin
            voltage <= 2'b01;   // Set to 1.8V
            frequency <= 2'b01; // Set to 2.5GHz
        end
    end
end
endmodule