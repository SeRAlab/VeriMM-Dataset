module current_sensor_controller (
    input clk,
    input rst,
    input [3:0] current_level,
    output reg alert
);
    reg prev_alert;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            alert <= 0;
            prev_alert <= 0;
        end else begin
            if (current_level > 4'd10) begin
                alert <= 1;
            end else if (current_level <= 4'd10 && prev_alert == 1) begin
                alert <= 0;
            end
            prev_alert <= alert;
        end
    end
endmodule