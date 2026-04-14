module adder_subtractor(
    input wire [3:0] A,
    input wire [3:0] B,
    input wire ctrl,
    output wire [3:0] result
);

assign result = ctrl ? (A + B) : (A - B);

endmodule