module top_module(
    input clk,
    input rst,
    input [3:0] bin_in,
    output reg [3:0] bcd_out
);always @ (posedge clk or posedge rst) begin
        if (rst) begin
            bcd_out <= 4'b0;
        end else begin
            case (bin_in)
                4'b0000: bcd_out <= 4'b0000;
                4'b0001: bcd_out <= 4'b0001;
                4'b0010: bcd_out <= 4'b0010;
                4'b0011: bcd_out <= 4'b0011;
                4'b0100: bcd_out <= 4'b0100;
                4'b0101: bcd_out <= 4'b0101;
                4'b0110: bcd_out <= 4'b0110;
                4'b0111: bcd_out <= 4'b0111;
                4'b1000: bcd_out <= 4'b1000;
                4'b1001: bcd_out <= 4'b1001;
                4'b1010: bcd_out <= 4'b1010; // Changed from 4'b10110
                4'b1011: bcd_out <= 4'b1011; // Changed from 4'b10111
                4'b1100: bcd_out <= 4'b1100; // Changed from 4'b11000
                4'b1101: bcd_out <= 4'b1101; // Changed from 4'b11001
                4'b1110: bcd_out <= 4'b1110; // Changed from 4'b11010
                4'b1111: bcd_out <= 4'b1111; // Changed from 4'b11011
                default: bcd_out <= 4'bxxxx;
            endcase
        end
    end
endmodule