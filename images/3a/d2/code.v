module ldo_regulator (
    input wire enable,          // Enable signal for LDO
    input wire [7:0] v_ref,    // Reference voltage input
    input wire [7:0] v_fb,     // Feedback voltage input
    output reg control          // Control output signal
);

always @(*) begin
    if (enable) begin
        if (v_fb < v_ref) begin
            control = 1; // Enable LDO
        end else begin
            control = 0; // Disable LDO
        end
    end else begin
        control = 0; // Disable LDO if not enabled
    end
end

endmodule