module temperature_sensor (
    input [9:0] temperature, // 10-bit input for temperature
    output reg [3:0] tens,    // 4-bit for tens digit
    output reg [3:0] units    // 4-bit for units digit
);

always @(*) begin
    if (temperature > 10'd99) begin
        tens = 4'b1111;  // Out of range indication
        units = 4'b1111; // Out of range indication
    end else begin
        tens = temperature / 10; // Calculate tens
        units = temperature % 10; // Calculate units
    end
end

endmodule