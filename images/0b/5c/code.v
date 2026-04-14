module temp_sensor_controller(
    input clk,
    input rst,
    input [3:0] temp_input,
    output reg safe_temp
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        safe_temp <= 0;
    end else begin
        if (temp_input >= 4'd1 && temp_input <= 4'd10) begin
            safe_temp <= 1;
        end else begin
            safe_temp <= 0;
        end
    end
end

endmodule