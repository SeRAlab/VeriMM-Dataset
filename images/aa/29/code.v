module logic_circuit (
    input e,
    input f,
    input g,
    input h,
    output reg u);assign u = ~e&~f&g&~h | e&~f&g&h | e&f&g&~h | e&~f&~g&~h;

endmodule