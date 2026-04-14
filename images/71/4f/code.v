module top_module(input A, B, C, output Q);parameter [7:0] LUT = 8'h00;

`ifdef cyclonev
specify
    (A => Q) = 510;
    (B => Q) = 400;
    (C => Q) = 97;
endspecify
`endif
`ifdef arriav
specify
    (A => Q) = 316;
    (B => Q) = 317;
    (C => Q) = 76;
endspecify
`endif
`ifdef cyclone10gx
specify
    (A => Q) = 165;
    (B => Q) = 162;
    (C => Q) = 53;
endspecify
`endif

assign Q = LUT >> {C, B, A};

endmodule