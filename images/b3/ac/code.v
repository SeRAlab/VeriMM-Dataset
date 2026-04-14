module result_module (
    input e,
    input f,
    input g,
    input h,
    output reg m);assign m = e&~f&~g&h | ~e&f&~g&~h | e&f&g&~h | e&~f&g&h | ~e&~f&g&~h;

endmodule