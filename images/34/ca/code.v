module voltage_sensor(
    input [4:0] voltage_in,
    output reg [2:0] level_out
);
    always @(*) begin
        if (voltage_in <= 5'd15) begin
            level_out = 3'b000; // Low
        end else if (voltage_in <= 5'd31) begin
            level_out = 3'b001; // Medium
        end else begin
            level_out = 3'b010; // High
        end
    end
endmodule