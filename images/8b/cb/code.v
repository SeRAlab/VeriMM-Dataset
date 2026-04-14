module condition_module (
    input r,
    input s,
    input t,
    input u,
    output reg q);assign q = ~r&s&~t&u | r&~s&t&~u | r&s&~t&u | ~r&s&t&~u | r&~s&~t&u;

endmodule