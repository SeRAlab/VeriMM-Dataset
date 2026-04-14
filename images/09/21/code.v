module dvfs_controller (
    input clk,
    input reset,
    input [6:0] temperature, // 0 to 100
    output reg [3:0] voltage, // 1.0V = 4'b0001, 1.2V = 4'b0010, 1.5V = 4'b0011
    output reg [3:0] frequency // 1.0GHz = 4'b0001, 1.5GHz = 4'b0010, 2.0GHz = 4'b0011
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            voltage <= 4'b0001; // Default to 1.0V
            frequency <= 4'b0001; // Default to 1.0GHz
        end else begin
            if (temperature < 40) begin
                voltage <= 4'b0001; // 1.0V
                frequency <= 4'b0001; // 1.0GHz
            end else if (temperature < 70) begin
                voltage <= 4'b0010; // 1.2V
                frequency <= 4'b0010; // 1.5GHz
            end else begin
                voltage <= 4'b0011; // 1.5V
                frequency <= 4'b0011; // 2.0GHz
            end
        end
    end
endmodule