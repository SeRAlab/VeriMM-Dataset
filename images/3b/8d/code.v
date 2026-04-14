module ADC (
    input [7:0] voltage_input,
    output reg [2:0] range_output
);
    always @(*) begin
        if (voltage_input <= 8'd84) begin
            range_output = 3'b000; // Range 0 to 84
        end else if (voltage_input <= 8'd169) begin
            range_output = 3'b001; // Range 85 to 169
        end else begin
            range_output = 3'b010; // Range 170 to 255
        end
    end
endmodule