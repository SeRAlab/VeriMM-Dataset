module power_gate (
    input wire power_enable,
    input wire power_consumption_level, // 0 for low, 1 for high
    output reg power_output
);

always @(*) begin
    if (power_enable && !power_consumption_level) begin
        power_output = 1; // Power enabled
    end else begin
        power_output = 0; // Power disabled
    end
end

endmodule