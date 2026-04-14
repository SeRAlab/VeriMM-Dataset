module xor_gate(
    input a,
    input b,
    output out_wire
);

    assign out_wire = a ^ b;

endmodule

module top_module(
    input a,
    input b,
    output out_wire
);

    xor_gate xor_inst(
        .a(a),
        .b(b),
        .out_wire(out_wire)
    );

endmodule