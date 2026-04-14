module top_module(
    input [3:0] bin_in,
    output reg [6:0] bcd_out_1,
    output reg [6:0] bcd_out_2
);always @*
begin
    case(bin_in)
        4'b0000: begin
            bcd_out_1 = 7'b0000000;
            bcd_out_2 = 7'b0000000;
        end
        4'b0001: begin
            bcd_out_1 = 7'b0000000;
            bcd_out_2 = 7'b0000001;
        end
        4'b0010: begin
            bcd_out_1 = 7'b0000000;
            bcd_out_2 = 7'b0000010;
        end
        4'b0011: begin
            bcd_out_1 = 7'b0000000;
            bcd_out_2 = 7'b0000011;
        end
        4'b0100: begin
            bcd_out_1 = 7'b0000000;
            bcd_out_2 = 7'b0000100;
        end
        4'b0101: begin
            bcd_out_1 = 7'b0000000;
            bcd_out_2 = 7'b0000101;
        end
        4'b0110: begin
            bcd_out_1 = 7'b0000000;
            bcd_out_2 = 7'b0000110;
        end
        4'b0111: begin
            bcd_out_1 = 7'b0000000;
            bcd_out_2 = 7'b0000111;
        end
        4'b1000: begin
            bcd_out_1 = 7'b0000001;
            bcd_out_2 = 7'b0000000;
        end
        4'b1001: begin
            bcd_out_1 = 7'b0000001;
            bcd_out_2 = 7'b0000001;
        end
        4'b1010: begin
            bcd_out_1 = 7'b0000001;
            bcd_out_2 = 7'b0000010;
        end
        4'b1011: begin
            bcd_out_1 = 7'b0000001;
            bcd_out_2 = 7'b0000011;
        end
        4'b1100: begin
            bcd_out_1 = 7'b0000001;
            bcd_out_2 = 7'b0000100;
        end
        4'b1101: begin
            bcd_out_1 = 7'b0000001;
            bcd_out_2 = 7'b0000101;
        end
        4'b1110: begin
            bcd_out_1 = 7'b0000001;
            bcd_out_2 = 7'b0000110;
        end
        4'b1111: begin
            bcd_out_1 = 7'b0000001;
            bcd_out_2 = 7'b0000111;
        end
    endcase
end

endmodule