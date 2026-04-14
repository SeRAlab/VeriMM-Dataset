module top_module(
    input clk,           // Added clk input
    input button,
    input sensor,
    output reg red,
    output reg green
);localparam CYCLE_COUNT = 10; // Number of clock cycles for green state
    
    reg [3:0] count; // Counter for green state
    
    always @(posedge clk) begin
        if (sensor) begin
            // Sensor input is high, immediately transition to red state
            red <= 1;
            green <= 0;
            count <= 0;
        end else if (button) begin
            // Button input is high, transition to green state
            red <= 0;
            green <= 1;
            count <= 0;
        end else if (count < CYCLE_COUNT) begin
            // Continue in green state
            red <= 0;
            green <= 1;
            count <= count + 1;
        end else begin
            // Transition back to red state
            red <= 1;
            green <= 0;
            count <= 0;
        end
    end

endmodule