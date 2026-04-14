module DVFS_Controller (
    input wire clk,
    input wire [1:0] voltage, // 2-bit voltage input
    output reg [1:0] frequency // 2-bit output frequency
);

    always @(posedge clk) begin
        case (voltage)
            2'b00: frequency <= 2'b00; // low frequency
            2'b01: frequency <= 2'b01; // medium frequency
            2'b10: frequency <= 2'b10; // high frequency
            default: frequency <= 2'b00; // default to low
        endcase
    end
endmodule