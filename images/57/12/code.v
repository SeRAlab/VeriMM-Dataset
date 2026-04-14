module top_module(
Clk,MinuteCarry,Control,countPlus
    );input Clk,MinuteCarry,Control;
    output countPlus;
    wire countPlus;

        
        assign countPlus=(Control)?Clk:MinuteCarry;endmodule