module phase_shifter (
    input clk,
    input rst,
    input [7:0] phase_in,   // Input phase in degrees (0-255)
    input [7:0] shift,      // Shift amount in degrees (0-255)
    output reg [7:0] phase_out // Output shifted phase
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            phase_out <= 8'b0;
        end else begin
            phase_out <= (phase_in + shift) % 256; // Wrap around using modulo
        end
    end
endmodule