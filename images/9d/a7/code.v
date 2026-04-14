module top_module(
    input wire [7:0] sensor_bus,
    input wire reset,
    input wire clk,
    output reg alarm
);reg [7:0] sensor_state;

// Read the state of the sensors on every clock cycle
always @(posedge clk) begin
    if (reset) begin
        sensor_state <= 8'h00;
    end else begin
        sensor_state <= sensor_bus;
    end
end

// Set the alarm if any of the sensors are triggered
always @(posedge clk) begin
    if (reset) begin
        alarm <= 0;
    end else begin
        if (sensor_state != 8'h00) begin
            alarm <= 1;
        end else begin
            alarm <= 0;
        end
    end
end

endmodule