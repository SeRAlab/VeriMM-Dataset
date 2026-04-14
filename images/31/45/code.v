module temperature_sensor (
    input [3:0] temp_in,
    output reg [2:0] temp_out
);

always @(*) begin
    if (temp_in < 4'd5) begin
        temp_out = 3'b000; // Cold
    end else if (temp_in >= 4'd5 && temp_in <= 4'd10) begin
        temp_out = 3'b001; // Cool
    end else if (temp_in >= 4'd11 && temp_in <= 4'd15) begin
        temp_out = 3'b010; // Warm
    end else begin
        temp_out = 3'b011; // Hot
    end
end

endmodule