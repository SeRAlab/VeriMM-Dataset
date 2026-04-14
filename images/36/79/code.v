module temp_sensor_converter(
    input [2:0] temp_in,
    output reg [1:0] temp_out
);
    always @(*) begin
        if (temp_in <= 3'd2) begin
            temp_out = 2'b00; // Low
        end else if (temp_in <= 3'd5) begin
            temp_out = 2'b01; // Medium
        end else begin
            temp_out = 2'b10; // High
        end
    end
endmodule