module decision_module (
    input u,
    input v,
    input w,
    input x,
    output reg t);assign t = ~u&v&~w&x | u&~v&w&x | u&v&~w&~x | ~u&v&w&~x | u&v&w&~x;

endmodule