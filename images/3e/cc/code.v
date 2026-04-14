module temperature_monitor(
    input clk,
    input reset,
    input [7:0] current_temp,
    output reg [7:0] avg_temp
);
    reg [7:0] temp_values [0:4]; // Array to hold last 5 temperature readings
    reg [2:0] count; // Count of stored temperatures
    reg [11:0] sum; // Sum of temperatures for average calculation

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            avg_temp <= 8'b0;
            count <= 3'b0;
            sum <= 12'b0;
        end else begin
            // Shift temperatures
            if (count < 5) begin
                temp_values[count] <= current_temp;
                sum <= sum + current_temp;
                count <= count + 1;
            end else begin
                sum <= sum - temp_values[0] + current_temp;
                temp_values[0] <= temp_values[1];
                temp_values[1] <= temp_values[2];
                temp_values[2] <= temp_values[3];
                temp_values[3] <= temp_values[4];
                temp_values[4] <= current_temp;
            end
            avg_temp <= sum / (count < 5 ? count + 1 : 5);
        end
    end
endmodule