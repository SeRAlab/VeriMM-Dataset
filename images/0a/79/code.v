module temperature_sensor(
    input [4:0] temp,
    output reg [2:0] temp_status
);

always @(*) begin
    if (temp <= 5'b01010) begin // 0 to 10
        temp_status = 3'b000; // Low
    end else if (temp <= 5'b10100) begin // 11 to 20
        temp_status = 3'b001; // Medium
    end else begin // 21 to 31
        temp_status = 3'b010; // High
    end
end

endmodule