module fan_speed_controller(
    input wire clk,
    input wire [2:0] temp,
    output reg [1:0] speed
);
    always @(posedge clk) begin
        case (temp)
            3'b000, 3'b001, 3'b010: speed <= 2'b00; // Low speed
            3'b011, 3'b100, 3'b101: speed <= 2'b01; // Medium speed
            3'b110, 3'b111: speed <= 2'b10; // High speed
            default: speed <= 2'b00; // Default to low speed
        endcase
    end
endmodule