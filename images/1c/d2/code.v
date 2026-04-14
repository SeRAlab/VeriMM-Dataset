module dvfs_controller (
    input wire clk,
    input wire [1:0] voltage,  // Assuming voltage is a 2-bit representation of the range
    output reg [31:0] frequency // Frequency output
);

    always @(posedge clk) begin
        case (voltage)
            2'b00: frequency <= 32'd1000000000; // 1 GHz
            2'b01: frequency <= 32'd2000000000; // 2 GHz
            2'b10: frequency <= 32'd3000000000; // 3 GHz
            default: frequency <= 32'd0;         // Default case
        endcase
    end
endmodule