module dvfs_controller (
    input clk,
    input reset,
    input [2:0] control_signal,
    output reg [3:0] voltage,
    output reg [3:0] frequency
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        voltage <= 4'b0000; // Default voltage
        frequency <= 4'b0000; // Default frequency
    end else begin
        case (control_signal)
            3'b000: begin voltage <= 4'b0001; frequency <= 4'b0001; end // State 0
            3'b001: begin voltage <= 4'b0010; frequency <= 4'b0010; end // State 1
            3'b010: begin voltage <= 4'b0011; frequency <= 4'b0011; end // State 2
            3'b011: begin voltage <= 4'b0100; frequency <= 4'b0100; end // State 3
            3'b100: begin voltage <= 4'b0101; frequency <= 4'b0101; end // State 4
            3'b101: begin voltage <= 4'b0110; frequency <= 4'b0110; end // State 5
            3'b110: begin voltage <= 4'b0111; frequency <= 4'b0111; end // State 6
            3'b111: begin voltage <= 4'b1000; frequency <= 4'b1000; end // State 7
            default: begin voltage <= 4'b0000; frequency <= 4'b0000; end // Default
        endcase
    end
end

endmodule