module fan_speed_controller (
    input clk,
    input reset,
    input [1:0] control,
    output reg [1:0] speed
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            speed <= 2'b00; // Default to Low speed on reset
        end else begin
            case (control)
                2'b00: speed <= 2'b00; // Low speed
                2'b01: speed <= 2'b01; // Medium speed
                2'b10: speed <= 2'b10; // High speed
                2'b11: speed <= 2'b11; // Off
                default: speed <= speed; // Maintain current speed
            endcase
        end
    end
endmodule