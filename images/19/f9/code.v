module dvfs_controller(
    input wire clk,
    input wire reset,
    input wire [1:0] Req,
    output reg [3:0] V_out,
    output reg [3:0] F_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        V_out <= 4'b0000; // Default to low voltage
        F_out <= 4'b0000; // Default to low frequency
    end else begin
        case (Req)
            2'b00: begin
                V_out <= 4'b0001; // Low voltage
                F_out <= 4'b0001; // Low frequency
            end
            2'b01: begin
                V_out <= 4'b0010; // Medium voltage
                F_out <= 4'b0010; // Medium frequency
            end
            2'b10: begin
                V_out <= 4'b0011; // High voltage
                F_out <= 4'b0011; // High frequency
            end
            2'b11: begin
                V_out <= 4'b0100; // Maximum voltage
                F_out <= 4'b0100; // Maximum frequency
            end
            default: begin
                V_out <= 4'b0000; // Should not happen
                F_out <= 4'b0000; // Should not happen
            end
        endcase
    end
end

endmodule