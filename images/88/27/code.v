module top_module(input A, output Q);`ifdef cyclonev
specify
    (A => Q) = 97;
endspecify
`endif
`ifdef arriav
specify
    (A => Q) = 76;
endspecify
`endif
`ifdef cyclone10gx
specify
    (A => Q) = 53;
endspecify
`endif

assign Q = ~A;

endmodule