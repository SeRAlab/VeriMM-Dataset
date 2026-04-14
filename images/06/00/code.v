module activation_function (
    input wire [7:0] x,
    input wire [7:0] threshold,
    output wire y
);
    assign y = (x >= threshold) ? 1 : 0;
endmodule