module DVFS_Controller(
    input wire clk,
    input wire reset,
    input wire request,
    output reg [1:0] voltage,
    output reg [1:0] frequency
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            voltage <= 2'b00;  // Default voltage level
            frequency <= 2'b00; // Default frequency level
        end else if (request) begin
            // Change voltage and frequency levels based on some conditions.
            // For simplicity, just toggle between two states.
            if (voltage == 2'b00) begin
                voltage <= 2'b01;
                frequency <= 2'b01;
            end else begin
                voltage <= 2'b00;
                frequency <= 2'b00;
            end
        end
    end
endmodule