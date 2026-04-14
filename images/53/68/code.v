module mux_2to1_4bit(
    input wire [3:0] in0,
    input wire [3:0] in1,
    input wire sel,
    output wire [3:0] out
    );

assign out = (sel == 1'b0) ? in0 : in1;

endmodule