module fan_speed_controller(
    input wire clk,
    input wire reset,
    input wire [3:0] temperature,
    output reg [1:0] fan_speed
);
    
    // Fan speed states
    localparam LOW = 2'b00;
    localparam MEDIUM = 2'b01;
    localparam HIGH = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            fan_speed <= LOW; // Default to low speed on reset
        end else begin
            if (temperature <= 4'd5) begin
                fan_speed <= LOW;
            end else if (temperature <= 4'd10) begin
                fan_speed <= MEDIUM;
            end else begin
                fan_speed <= HIGH;
            end
        end
    end
endmodule