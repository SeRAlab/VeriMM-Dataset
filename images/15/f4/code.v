module fan_speed_control(
    input clk,
    input rst,
    input [2:0] T,
    output reg [1:0] F
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        F <= 2'b00; // Fan Off
    end else begin
        case (T)
            3'b000, 3'b001, 3'b010: F <= 2'b00;  // Fan Off
            3'b011, 3'b100, 3'b101: F <= 2'b01;  // Low Speed
            3'b110, 3'b111: F <= 2'b10;          // High Speed
            default: F <= 2'b00;                  // Default to Off
        endcase
    end
end

endmodule