module temperature_monitor(
    input [3:0] temperature,
    input clk,
    input reset,
    output reg [2:0] alarm
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            alarm <= 3'b000;
        end else begin
            if (temperature > 4'b1010) begin // If temperature > 10
                alarm <= 3'b111; // Set alarm
            end else begin
                alarm <= 3'b000; // Clear alarm
            end
        end
    end
endmodule