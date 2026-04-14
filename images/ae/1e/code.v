module top_module(input wire RTS,
            input wire DTR,
            output wire LED0,
            output wire LED7);assign {LED0, LED7} = {DTR, RTS};

endmodule