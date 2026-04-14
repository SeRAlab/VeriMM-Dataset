module swap_bits ( input [1:0] A, output [1:0] Q );

    assign Q = { A[0], A[1] };

endmodule