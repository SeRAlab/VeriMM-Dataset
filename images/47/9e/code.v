module top_module(
    input [15:0] A,
    input [15:0] B,
    input MODE,
    input CIN,
    output [15:0] Q,
    output overflow
);wire [15:0] sum;
    wire carry_out;
    wire overflow_detect;

    // Full adder for 16-bit addition/subtraction
    function [15:0] full_adder_16;
        input [15:0] A;
        input [15:0] B;
        input CIN;
        reg [15:0] SUM;
        reg COUT;
        integer i;
        begin
            SUM = 0;
            COUT = CIN;
            for (i = 0; i < 16; i = i + 1) begin
                {COUT, SUM[i]} = A[i] + B[i] + COUT;
            end
            full_adder_16 = {COUT, SUM[15:0]};
        end
    endfunction

    // Overflow detector for 16-bit signed numbers
    function overflow_detector_16;
        input [15:0] A;
        input [15:0] B;
        input [15:0] SUM;
        input CIN;
        reg overflow;
        begin
            overflow = (A[15] == B[15]) && (SUM[15] != A[15]);
            overflow_detector_16 = overflow;
        end
    endfunction

    // Compute sum based on mode
    assign {carry_out, sum} = full_adder_16(A, B, CIN);
    assign overflow_detect = overflow_detector_16(A, B, sum, CIN);

    // Final output assignment
    assign Q = (MODE) ? (A - B - CIN) : (A + B + CIN);
    assign overflow = overflow_detect;

endmodule