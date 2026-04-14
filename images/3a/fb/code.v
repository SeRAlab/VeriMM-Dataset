module temperature_sensor (
    input [4:0] temp_in,
    output reg [2:0] temp_out
);
    always @(*) begin
        if (temp_in <= 5'd10) begin
            temp_out = 3'b000; // Low
        end else if (temp_in <= 5'd20) begin
            temp_out = 3'b001; // Medium
        end else if (temp_in <= 5'd31) begin
            temp_out = 3'b010; // High
        end else begin
            temp_out = 3'b111; // Invalid
        end
    end
endmodule