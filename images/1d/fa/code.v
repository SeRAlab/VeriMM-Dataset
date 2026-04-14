module DVFS_Controller (
    input [4:0] voltage,
    input enable,
    input reset,
    output reg frequency
);
    always @(posedge enable or posedge reset) begin
        if (reset) begin
            frequency <= 0; // Initialize frequency to low
        end else begin
            if (voltage > 5'b10000) begin // Threshold voltage (16)
                frequency <= 1; // High frequency
            end else begin
                frequency <= 0; // Low frequency
            end
        end
    end
endmodule