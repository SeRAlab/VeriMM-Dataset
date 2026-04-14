module dvfs_controller (
    input wire clk,
    input wire reset,
    input wire [2:0] voltage,
    output reg [2:0] frequency
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            frequency <= 3'b000;
        end else begin
            if (voltage < 3'b011) begin
                frequency <= voltage - 1; // Reduce frequency
            end else begin
                frequency <= voltage; // Direct mapping
            end
        end
    end
endmodule