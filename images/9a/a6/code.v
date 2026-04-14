module top_module (
        input e,
        input f,
        input g,
        output h);assign h = ( ~e & ~f & g ) |
           ( ~e & f & ~g ) |
           ( e & ~f & ~g ) |
           ( e & f & g );

endmodule