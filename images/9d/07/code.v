module top_module (
    input clk,
    input reset,
    input enable,
    output reg [3:0] q
);

    // Gray code counter with enable logic
    always @(posedge clk) begin
        if (reset)
            q <= 4'b0000;
        else if (enable) begin
            case (q)
                4'b0000: q <= 4'b0001;
                4'b0001: q <= 4'b0011;
                4'b0011: q <= 4'b0010;
                4'b0010: q <= 4'b0110;
                4'b0110: q <= 4'b0111;
                4'b0111: q <= 4'b0101;
                4'b0101: q <= 4'b0100;
                4'b0100: q <= 4'b1100;
                4'b1100: q <= 4'b1101;
                4'b1101: q <= 4'b1111;
                4'b1111: q <= 4'b1110;
                4'b1110: q <= 4'b1010;
                4'b1010: q <= 4'b1011;
                4'b1011: q <= 4'b1001;
                4'b1001: q <= 4'b1000;
                4'b1000: q <= 4'b0000;
                default: q <= 4'b0000;
            endcase
        end
    end

endmodule