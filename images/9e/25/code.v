module top_module(i_a, i_b, i_sel, o_led, o_led1, o_led2, o_led3);input wire i_a, i_b, i_sel;
    output wire o_led;

    output wire o_led1;
    output wire o_led2;
    output wire o_led3;

    assign o_led = i_sel ? i_a : i_b;

    assign o_led1 = 0;
    assign o_led2 = 0;
    assign o_led3 = 0;

endmodule