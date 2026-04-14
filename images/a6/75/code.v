module top_module(input wire D13,  
            input wire D12,  
            output wire LED0,
            output wire LED1);assign {LED0, LED1} = {D13, D12};

endmodule