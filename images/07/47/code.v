module temp_sensor_controller (
    input wire clk,
    input wire reset,
    input wire [3:0] temp_input,
    output reg alert
);
    reg [3:0] last_temp;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            last_temp <= 4'b0000;
            alert <= 1'b0;
        end else begin
            last_temp <= temp_input;
            if (temp_input > 4'b1010) begin // 10 in decimal
                alert <= 1'b1; // Trigger alert
            end else begin
                alert <= 1'b0; // Normal
            end
        end
    end
endmodule