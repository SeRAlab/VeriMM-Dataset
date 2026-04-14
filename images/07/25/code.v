module voltage_sensor (
    input [4:0] voltage_input,
    output reg [2:0] voltage_category
);

always @(*) begin
    case (voltage_input)
        5'd0: voltage_category = 3'b000; // 0mV
        5'd1: voltage_category = 3'b000; // 1mV
        5'd2: voltage_category = 3'b000; // 2mV
        5'd3: voltage_category = 3'b000; // 3mV
        5'd4: voltage_category = 3'b000; // 4mV
        5'd5: voltage_category = 3'b000; // 5mV
        5'd6: voltage_category = 3'b000; // 6mV
        5'd7: voltage_category = 3'b000; // 7mV
        5'd8: voltage_category = 3'b000; // 8mV
        5'd9: voltage_category = 3'b000; // 9mV
        5'd10: voltage_category = 3'b000; // 10mV
        5'd11: voltage_category = 3'b001; // 11mV
        5'd12: voltage_category = 3'b001; // 12mV
        5'd13: voltage_category = 3'b001; // 13mV
        5'd14: voltage_category = 3'b001; // 14mV
        5'd15: voltage_category = 3'b001; // 15mV
        5'd16: voltage_category = 3'b001; // 16mV
        5'd17: voltage_category = 3'b001; // 17mV
        5'd18: voltage_category = 3'b001; // 18mV
        5'd19: voltage_category = 3'b001; // 19mV
        5'd20: voltage_category = 3'b001; // 20mV
        5'd21: voltage_category = 3'b010; // 21mV
        5'd22: voltage_category = 3'b010; // 22mV
        5'd23: voltage_category = 3'b010; // 23mV
        5'd24: voltage_category = 3'b010; // 24mV
        5'd25: voltage_category = 3'b010; // 25mV
        5'd26: voltage_category = 3'b010; // 26mV
        5'd27: voltage_category = 3'b010; // 27mV
        5'd28: voltage_category = 3'b010; // 28mV
        5'd29: voltage_category = 3'b010; // 29mV
        5'd30: voltage_category = 3'b010; // 30mV
        5'd31: voltage_category = 3'b011; // 31mV
        default: voltage_category = 3'b111; // out of range
    endcase
end

endmodule