module DVFS_Controller(
    input wire clk,
    input wire [1:0] mode,
    output reg [3:0] voltage,
    output reg [3:0] frequency
);
    always @(posedge clk) begin
        case (mode)
            2'b00: begin // Low mode
                voltage <= 4'b0001; // 1V
                frequency <= 4'b0010; // 2GHz
            end
            2'b01: begin // Medium mode
                voltage <= 4'b0010; // 2V
                frequency <= 4'b0100; // 4GHz
            end
            2'b10: begin // High mode
                voltage <= 4'b0100; // 4V
                frequency <= 4'b1000; // 8GHz
            end
            default: begin
                voltage <= 4'b0000; // Default case
                frequency <= 4'b0000; // Default case
            end
        endcase
    end
endmodule