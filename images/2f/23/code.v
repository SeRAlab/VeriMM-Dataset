module switching_regulator(
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [7:0] V_in,     // Input voltage
    input wire [7:0] V_fb,     // Feedback voltage
    output reg [7:0] V_out     // Output voltage
);

    parameter [7:0] V_ref = 8'd128; // Reference voltage (0-255)
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            V_out <= 8'd0; // Reset output voltage to 0
        end else if (enable) begin
            if (V_fb < V_ref) begin
                V_out <= V_out + 8'd1; // Increase output voltage
            end else if (V_fb > V_ref) begin
                V_out <= V_out - 8'd1; // Decrease output voltage
            end
        end
    end
endmodule