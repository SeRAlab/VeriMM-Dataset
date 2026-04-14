module wifi_signal_indicator (
    input [3:0] signal_strength,
    output reg [2:0] strength_level
);

always @(*) begin
    if (signal_strength <= 4) begin
        strength_level = 3'b000; // weak
    end else if (signal_strength <= 10) begin
        strength_level = 3'b001; // medium
    end else begin
        strength_level = 3'b010; // strong
    end
end

endmodule