module temp_shutdown (
    input wire clk,
    input wire rst,
    input wire temp_sensor,
    output reg shutdown
);
    parameter THRESHOLD = 8'd75; // Define the temperature threshold
    reg [7:0] current_temp; // Current temperature value

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_temp <= 0;
            shutdown <= 0;
        end else begin
            current_temp <= temp_sensor; // Assuming temp_sensor is an 8-bit input
            if (current_temp >= THRESHOLD) begin
                shutdown <= 1; // Trigger shutdown
            end else begin
                shutdown <= 0; // Reset shutdown
            end
        end
    end
endmodule