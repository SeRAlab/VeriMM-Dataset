module top_module(
    input clk,
    input reset,   // Synchronous active-high reset
    input [3:1] ena, // Asynchronous enable signals for tens, hundreds, and thousands digits
    output [15:0] q);reg [3:0] ones_digit = 4'b0000;
    reg [3:0] tens_digit = 4'b0000;
    reg [3:0] hundreds_digit = 4'b0000;
    reg [3:0] thousands_digit = 4'b0000;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ones_digit <= 4'b0000;
            tens_digit <= 4'b0000;
            hundreds_digit <= 4'b0000;
            thousands_digit <= 4'b0000;
        end else begin
            ones_digit <= ones_digit + 1;
        end
    end

    always @(ena) begin
        if (ena[0]) begin
            tens_digit <= tens_digit + 1;
        end
        if (ena[1]) begin
            hundreds_digit <= hundreds_digit + 1;
        end
        if (ena[2]) begin
            thousands_digit <= thousands_digit + 1;
        end
    end

    assign q = {thousands_digit, hundreds_digit, tens_digit, ones_digit};

endmodule