module logic_circuit (
    input x,
    input y,
    input z,
    output reg f);assign f = x&~y&z | x&y&~z | x&~y&~z | x&y&z;

endmodule