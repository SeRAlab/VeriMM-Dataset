module ones_comp (
    input [7:0] in,
    output [7:0] out
);

    // Voltage supply signals
    supply1 VDD;
    supply0 VSS;

    wire [7:0] in_not;
    assign in_not = ~in;

    assign out = in_not;

endmodule