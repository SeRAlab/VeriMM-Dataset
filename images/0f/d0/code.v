module DVFS_Controller(
    input [3:0] workload,
    input mode,
    output reg [2:0] frequency,
    output reg [1:0] voltage
);
    always @(*) begin
        voltage = workload[3:2]; // Upper 2 bits of workload for voltage
        if (mode) begin
            frequency = workload + 2; // High performance mode
        end else begin
            frequency = workload[2:0]; // Low power mode
        end
    end
endmodule