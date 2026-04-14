module top_module(
    input A,
    input B,
    input C,
    input D,
    output reg [3:0] out_high,
    output reg [3:0] out_low
);always @(*) begin
    case ({A,B,C,D})
        4'b0000: begin
            out_high = 4'b0000;
            out_low = 4'b0000;
        end
        4'b0001: begin
            out_high = 4'b0000;
            out_low = 4'b0001;
        end
        4'b0010: begin
            out_high = 4'b0000;
            out_low = 4'b0010;
        end
        4'b0011: begin
            out_high = 4'b0000;
            out_low = 4'b0011;
        end
        4'b0100: begin
            out_high = 4'b0000;
            out_low = 4'b0100;
        end
        4'b0101: begin
            out_high = 4'b0000;
            out_low = 4'b0101;
        end
        4'b0110: begin
            out_high = 4'b0000;
            out_low = 4'b0110;
        end
        4'b0111: begin
            out_high = 4'b0000;
            out_low = 4'b0111;
        end
        4'b1000: begin
            out_high = 4'b0001;
            out_low = 4'b0000;
        end
        4'b1001: begin
            out_high = 4'b0001;
            out_low = 4'b0001;
        end
        4'b1010: begin
            out_high = 4'b0001;
            out_low = 4'b0010;
        end
        4'b1011: begin
            out_high = 4'b0001;
            out_low = 4'b0011;
        end
        4'b1100: begin
            out_high = 4'b0001;
            out_low = 4'b0100;
        end
        4'b1101: begin
            out_high = 4'b0001;
            out_low = 4'b0101;
        end
        4'b1110: begin
            out_high = 4'b0001;
            out_low = 4'b0110;
        end
        4'b1111: begin
            out_high = 4'b0001;
            out_low = 4'b0111;
        end
    endcase
end

endmodule