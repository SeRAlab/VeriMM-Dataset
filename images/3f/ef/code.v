module vco (
    input wire clk,
    input wire rst,
    input wire [2:0] control, // 3-bit control input
    output reg [3:0] freq_out // 4-bit frequency output
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            freq_out <= 4'b0000; // Reset frequency output
        end else begin
            case (control)
                3'b000: freq_out <= 4'b0001; // 1
                3'b001: freq_out <= 4'b0010; // 2
                3'b010: freq_out <= 4'b0100; // 4
                3'b011: freq_out <= 4'b1000; // 8
                3'b100: freq_out <= 4'b0001; // Loop back to 1
                default: freq_out <= 4'b0000; // Default case
            endcase
        end
    end
endmodule