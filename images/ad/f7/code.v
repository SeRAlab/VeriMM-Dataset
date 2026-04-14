module logic_circuit (
    input g,
    input h,
    input i,
    output reg z);assign z = g&h&~i | ~g&~h&i | ~g&h&i | g&~h&~i | ~g&h&~i;

endmodule