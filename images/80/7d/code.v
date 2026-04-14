module top_module(
    input clk,
    input rst,
    output reg [3:0] gray_out
);always @ (posedge clk) begin
        if (rst) begin
            gray_out <= 4'b0000;
        end else begin
            case (gray_out)
                4'b0000: gray_out <= 4'b0001;
                4'b0001: gray_out <= 4'b0011;
                4'b0011: gray_out <= 4'b0010;
                4'b0010: gray_out <= 4'b0110;
                4'b0110: gray_out <= 4'b0111;
                4'b0111: gray_out <= 4'b0101;
                4'b0101: gray_out <= 4'b0100;
                4'b0100: gray_out <= 4'b1100;
                4'b1100: gray_out <= 4'b1101;
                4'b1101: gray_out <= 4'b1111;
                4'b1111: gray_out <= 4'b1110;
                4'b1110: gray_out <= 4'b1010;
                4'b1010: gray_out <= 4'b1011;
                4'b1011: gray_out <= 4'b1001;
                4'b1001: gray_out <= 4'b1000;
                4'b1000: gray_out <= 4'b0000;
            endcase
        end
    end

endmodule