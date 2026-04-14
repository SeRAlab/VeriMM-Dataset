module TemperatureSensorController(
    input wire clk,
    input wire [3:0] temperature,
    output reg high_temp_alert
);

    always @(posedge clk) begin
        if (temperature > 4'd25) 
            high_temp_alert <= 1'b1;
        else 
            high_temp_alert <= 1'b0;
    end

endmodule