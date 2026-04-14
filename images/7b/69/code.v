module top_module(input A, B, C, D, E, F, output Q);parameter [63:0] LUT = 64'h0000_0000_0000_0000;

`ifdef cyclonev
specify
    (A => Q) = 605;
    (B => Q) = 583;
    (C => Q) = 510;
    (D => Q) = 512;
    (E => Q) = 400;
    (F => Q) = 97;
endspecify
`endif
`ifdef arriav
specify
    (A => Q) = 387;
    (B => Q) = 375;
    (C => Q) = 316;
    (D => Q) = 317;
    (E => Q) = 319;
    (F => Q) = 76;
endspecify
`endif
`ifdef cyclone10gx
specify
    (A => Q) = 275;
    (B => Q) = 272;
    (C => Q) = 175;
    (D => Q) = 165;
    (E => Q) = 162;
    (F => Q) = 53;
endspecify
`endif

assign Q = LUT >> {F, E, D, C, B, A};

endmodule