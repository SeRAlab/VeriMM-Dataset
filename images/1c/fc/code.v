module voltage_sensor(
    input [4:0] voltage_in,
    output reg [2:0] voltage_out
);
    always @(*) begin
        if (voltage_in <= 5'd10) begin
            voltage_out = 3'b000; // Low
        end else if (voltage_in <= 5'd20) begin
            voltage_out = 3'b001; // Medium
        end else begin
            voltage_out = 3'b010; // High
        end
    end
endmodule