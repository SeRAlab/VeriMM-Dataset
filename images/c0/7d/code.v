module muxer(from_ram, from_const, const_effective, out);
    input [197:0] from_ram, from_const;
    input const_effective;
    output [197:0] out;
    assign out = const_effective ? from_const : from_ram;
endmodule