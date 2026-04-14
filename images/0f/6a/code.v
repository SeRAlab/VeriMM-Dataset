module temperature_control (
    input [3:0] temperature,
    input reset,
    input clk,
    output reg heater
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            heater <= 0;
        end else if (temperature > 4'b11001) begin // 25 in binary is 11001
            heater <= 1;
        end else begin
            heater <= 0;
        end
    end
endmodule