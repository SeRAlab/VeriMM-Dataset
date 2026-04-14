module digital_phase_shifter (
    input wire clk,
    input wire rst,
    input wire [2:0] control,
    output reg phase_out
);

reg [2:0] phase;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        phase <= 3'b000;
    end else begin
        phase <= control;
    end
end

always @(phase) begin
    case (phase)
        3'b000: phase_out = 1'b0;  // 0 degrees
        3'b001: phase_out = 1'b1;  // 45 degrees
        3'b010: phase_out = 1'b1;  // 90 degrees
        3'b011: phase_out = 1'b1;  // 135 degrees
        3'b100: phase_out = 1'b1;  // 180 degrees
        3'b101: phase_out = 1'b1;  // 225 degrees
        3'b110: phase_out = 1'b1;  // 270 degrees
        3'b111: phase_out = 1'b1;  // 315 degrees
        default: phase_out = 1'b0;  // Default case
    endcase
end

endmodule