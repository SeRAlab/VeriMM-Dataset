module voltage_sensor (
    input [3:0] voltage, // voltage input (4 bits for up to 15V)
    output reg [1:0] level // output: 2 bits for level
);

always @(*) begin
    case (voltage)
        4'b0000: level = 2'b00; // 0V -> LOW
        4'b0101: level = 2'b01; // 5V -> MEDIUM
        4'b1010: level = 2'b10; // 10V -> HIGH
        default: level = 2'b11; // Invalid level
    endcase
end

endmodule