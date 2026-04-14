module top_module(output s,
            input  x,
            input  y,
            input  chave);assign s = (y & ~chave) | (x & y) | (x & ~chave);endmodule