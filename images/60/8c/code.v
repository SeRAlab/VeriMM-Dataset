module top_module(
    input [3:0] in,
    output reg [3:0] bcd_high,
    output reg [3:0] bcd_low
);always @(*) begin
        case (in)
            4'b0000: begin
                bcd_high = 4'b0000;
                bcd_low = 4'b0000;
            end
            4'b0001: begin
                bcd_high = 4'b0000;
                bcd_low = 4'b0001;
            end
            4'b0010: begin
                bcd_high = 4'b0000;
                bcd_low = 4'b0010;
            end
            4'b0011: begin
                bcd_high = 4'b0000;
                bcd_low = 4'b0011;
            end
            4'b0100: begin
                bcd_high = 4'b0001;
                bcd_low = 4'b0000;
            end
            4'b0101: begin
                bcd_high = 4'b0001;
                bcd_low = 4'b0001;
            end
            4'b0110: begin
                bcd_high = 4'b0001;
                bcd_low = 4'b0010;
            end
            4'b0111: begin
                bcd_high = 4'b0001;
                bcd_low = 4'b0011;
            end
            4'b1000: begin
                bcd_high = 4'b0010;
                bcd_low = 4'b0000;
            end
            4'b1001: begin
                bcd_high = 4'b0010;
                bcd_low = 4'b0001;
            end
            default: begin
                bcd_high = 4'b0000;
                bcd_low = 4'b0000;
            end
        endcase
    end

endmodule