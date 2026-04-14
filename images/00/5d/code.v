module current_sensor (
    input [4:0] current_level,
    output reg [2:0] severity
);

always @(*) begin
    if (current_level <= 5'd10)
        severity = 3'b000; // normal
    else if (current_level <= 5'd20)
        severity = 3'b001; // warning
    else if (current_level <= 5'd30)
        severity = 3'b010; // critical
    else
        severity = 3'b011; // danger
end

endmodule