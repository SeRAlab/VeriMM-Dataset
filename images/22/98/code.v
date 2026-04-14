module fan_speed_controller(
    input wire clk,
    input wire reset,
    input wire mode,
    input wire [4:0] temperature,
    output reg fan_speed
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            fan_speed <= 0;
        end else begin
            if (mode == 0) begin
                fan_speed <= (temperature > 20) ? 1 : 0;
            end else begin
                fan_speed <= (temperature > 15) ? 1 : 0;
            end
        end
    end
endmodule