module top_module(
    input clk,              // Clock input
    input reset,            // Synchronous active-high reset
    input [7:0] d,          // 8-bit input for the shift register
    output reg [6:0] seg     // 7-segment display output
);reg [3:0] count;        // 4-bit binary counter
    reg [7:0] shift_reg;    // 8-bit shift register

    always @(posedge clk) begin
        if (reset) begin
            count <= 4'b0000;
            shift_reg <= 8'b00000000;
        end else begin
            count <= count + 1;
            shift_reg <= {shift_reg[6:0], d[7]};
        end
    end

    always @(count, shift_reg) begin
        case (count)
            4'b0000: seg <= 7'b1111110; // 0
            4'b0001: seg <= 7'b0110000; // 1
            4'b0010: seg <= 7'b1101101; // 2
            4'b0011: seg <= 7'b1111001; // 3
            4'b0100: seg <= 7'b0110011; // 4
            4'b0101: seg <= 7'b1011011; // 5
            4'b0110: seg <= 7'b1011111; // 6
            4'b0111: seg <= 7'b1110000; // 7
            4'b1000: seg <= 7'b1111111; // 8
            4'b1001: seg <= 7'b1111011; // 9
            default: seg <= 7'b1111111; // Blank
        endcase
        seg[7:1] <= shift_reg + count;
    end

endmodule