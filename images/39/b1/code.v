module barrel_shifter (
    input [1:0] in,
    input control,
    output [1:0] out
);
    assign out = (control == 0) ? {in[0], in[1]} : {in[1], in[0]};
endmodule