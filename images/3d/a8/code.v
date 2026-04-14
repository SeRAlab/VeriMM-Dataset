module temperature_sensor(
    input [4:0] temp,
    output reg [2:0] status
);

always @(*) begin
    if (temp <= 5'd15) begin
        status = 3'b000; // Low
    end else if (temp <= 5'd25) begin
        status = 3'b001; // Medium
    end else if (temp <= 5'd31) begin
        status = 3'b010; // High
    end else begin
        status = 3'b111; // Invalid
    end
end

endmodule