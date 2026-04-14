module top_module(
    input             clk,      // 100MHz clock input, unused

    input             btnC,     // push button inputs
    input             btnU,
    input             btnD,
    input             btnR,
    input             btnL,

    input      [15:0] sw,       // slide switch inputs

    output reg [15:0] led,      // LED outputs

    output reg  [6:0] seg,      // 7-segment display outputs, active low
    output reg        dp,       // decimal point, active low
    output reg  [3:0] an        // common anodes, active low
);initial seg = 7'b1111111;   // clear 7-segment display

    initial an = 4'b1111;       // all digits enabled

    always @(btnC or btnU or btnD or btnR or btnL) begin
        // Buttons control the digit on 7-segment LED.
        seg[0] <= ~btnU;

        seg[1] <= ~btnR;
        seg[2] <= ~btnR;

        seg[3] <= ~btnD;

        seg[4] <= ~btnL;
        seg[5] <= ~btnL;

        seg[6] <= ~btnC;

        // Highlight the dot when no button pressed.
        dp <= ~(btnU | btnL | btnC | btnR | btnD);
    end

endmodule