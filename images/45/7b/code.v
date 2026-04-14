module top_module(
    input wire [1:0] control,
    input wire [31:0] a,b,c,d,
    output wire [31:0] selected
);assign selected = (control[1]) ? (control[0]?d:c) : (control[0]?b:a);

endmodule