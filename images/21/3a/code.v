module temperature_sensor_controller (
    input [9:0] temp_in,
    input enable,
    input reset,
    output reg alert
);
    
    always @(posedge enable or posedge reset) begin
        if (reset) begin
            alert <= 0;
        end else begin
            if (temp_in > 10'd75) begin
                alert <= 1;
            end else if (temp_in < 10'd60) begin
                alert <= 0;
            end
            // If temp_in is between 60 and 75, alert remains unchanged
        end
    end
endmodule