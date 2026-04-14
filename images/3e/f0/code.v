module LDO_Regulator (
    input wire [7:0] V_ref,  // Reference voltage (8-bit)
    input wire [7:0] V_fb,   // Feedback voltage (8-bit)
    output reg V_ctrl        // Control signal (PWM)
);
    always @(*) begin
        if (V_fb < V_ref) begin
            V_ctrl = 1; // Turn on pass transistor
        end else begin
            V_ctrl = 0; // Turn off pass transistor
        end
    end
endmodule