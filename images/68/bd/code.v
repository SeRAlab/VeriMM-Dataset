module top_module(
    input clk,
    input [3:0] bin_in,
    output reg [6:0] led_out
);always @(posedge clk) begin
        if (bin_in == 4'd0) led_out = 7'b1000000;
        else if (bin_in == 4'd1) led_out = 7'b1111001;
        else if (bin_in == 4'd2) led_out = 7'b0100100;
        else if (bin_in == 4'd3) led_out = 7'b0110000;
        else if (bin_in == 4'd4) led_out = 7'b0011001;
        else if (bin_in == 4'd5) led_out = 7'b0010010;
        else if (bin_in == 4'd6) led_out = 7'b0000010;
        else if (bin_in == 4'd7) led_out = 7'b1111000;
        else if (bin_in == 4'd8) led_out = 7'b0000000;
        else if (bin_in == 4'd9) led_out = 7'b0011000;
        else if (bin_in == 4'd10) led_out = 7'b0000100;
        else if (bin_in == 4'd11) led_out = 7'b0000001;
        else if (bin_in == 4'd12) led_out = 7'b1100000;
        else if (bin_in == 4'd13) led_out = 7'b0010100;
        else if (bin_in == 4'd14) led_out = 7'b0000110;
        else if (bin_in == 4'd15) led_out = 7'b0001110;
    end

endmodule