module top_module(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    input Mode,
    output [3:0] Sum,
    output Cout
);wire [3:0] adder_out;
    wire C1, C2, C3;

    // Full adder implementation
    function [1:0] full_adder;
        input a, b, cin;
        begin
            full_adder[0] = a ^ b ^ cin; // Sum
            full_adder[1] = (a & b) | (cin & (a ^ b)); // Carry out
        end
    endfunction

    // Instantiate the full adders
    assign {C1, adder_out[0]} = full_adder(A[0], B[0] ^ Mode, Cin);
    assign {C2, adder_out[1]} = full_adder(A[1], B[1] ^ Mode, C1);
    assign {C3, adder_out[2]} = full_adder(A[2], B[2] ^ Mode, C2);
    assign {Cout, adder_out[3]} = full_adder(A[3], B[3] ^ Mode, C3);

    assign Sum = adder_out;

endmodule