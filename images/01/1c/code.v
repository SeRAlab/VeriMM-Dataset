module fan_speed_control (
    input wire clk,
    input wire reset,
    input wire [1:0] control,
    output reg [1:0] speed
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            speed <= 2'b00; // OFF
        end else begin
            case (control)
                2'b00: speed <= 2'b00; // OFF
                2'b01: speed <= 2'b01; // LOW
                2'b10: speed <= 2'b10; // MEDIUM
                2'b11: speed <= 2'b11; // HIGH
                default: speed <= speed; // Maintain current speed
            endcase
        end
    end
endmodule