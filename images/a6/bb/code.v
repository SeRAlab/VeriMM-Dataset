module top_module(input wire SW1,
            input wire SW2,
            output wire LED0,
            output wire LED1);assign {LED0, LED1} = {SW1, SW2};

endmodule