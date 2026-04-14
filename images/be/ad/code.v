module top_module(
    input clk,
    input rst,
    input [3:0] bin_in,
    output reg [9:0] bcd_out
);always @(posedge clk or posedge rst) begin
    if (rst) begin
        bcd_out <= 10'b0;
    end else begin
        case (bin_in)
            4'b0000: bcd_out <= 10'b0000_0000; // 0
            4'b0001: bcd_out <= 10'b0000_0001; // 1
            4'b0010: bcd_out <= 10'b0000_0010; // 2
            4'b0011: bcd_out <= 10'b0000_0011; // 3
            4'b0100: bcd_out <= 10'b0000_0100; // 4
            4'b0101: bcd_out <= 10'b0000_0101; // 5
            4'b0110: bcd_out <= 10'b0000_0110; // 6
            4'b0111: bcd_out <= 10'b0000_0111; // 7
            4'b1000: bcd_out <= 10'b0000_1000; // 8
            4'b1001: bcd_out <= 10'b0000_1001; // 9
            default: bcd_out <= 10'b0000_0000; // Default case to handle invalid input
        endcase
    end
end

endmodule