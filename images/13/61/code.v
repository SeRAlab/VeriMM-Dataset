module fan_speed_control (
    input wire clk,
    input wire [1:0] temp_input,
    output reg [1:0] fan_speed
);
    always @(posedge clk) begin
        case (temp_input)
            2'b00: fan_speed <= 2'b00; // Low speed
            2'b01: fan_speed <= 2'b01; // Medium speed
            2'b10: fan_speed <= 2'b10; // High speed
            default: fan_speed <= 2'b00; // Default to low speed
        endcase
    end
endmodule