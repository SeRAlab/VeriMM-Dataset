module simple_module (
    input k, 
    input l, 
    output m);assign m = (~k & ~l) | (~k & l);

endmodule