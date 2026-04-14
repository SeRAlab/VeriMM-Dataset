module logic_module (
    input p, 
    input q, 
    input r, 
    input s,
    output reg result);assign result = (~p & q & ~r & s) | (~p & ~q & r & s) | (p & q & r & s) | (p & q & ~r & s);

endmodule