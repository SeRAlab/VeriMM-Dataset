module top_module (
    input en,
    input [7:0] a,
    output [7:0] y
);

    // Perform logical OR with enable
    assign y = en ? a : 8'b11111111;

endmodule