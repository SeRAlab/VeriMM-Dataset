module top_module(
    input [3:0] bin,
    output reg [3:0] dec // Change output width to 4 bits to accommodate the range 0-9.
);always @(*) begin
        case(bin)
            4'b0000: dec = 4'd0;
            4'b0001: dec = 4'd1;
            4'b0010: dec = 4'd2;
            4'b0011: dec = 4'd3;
            4'b0100: dec = 4'd4;
            4'b0101: dec = 4'd5;
            4'b0110: dec = 4'd6;
            4'b0111: dec = 4'd7;
            4'b1000: dec = 4'd8;
            4'b1001: dec = 4'd9;
            default: dec = 4'd0; // Set default to 0 instead of an out-of-range value.
        endcase
    end

endmodule