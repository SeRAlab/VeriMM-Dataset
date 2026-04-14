module top_module(f_bit, s_bit, carry_in, carry_out, s);input f_bit;
    input s_bit;
    input carry_in;
    output s;
    output carry_out;


    assign s = f_bit ^ s_bit ^ carry_in;
    assign carry_out = (f_bit & s_bit) | (carry_in & (f_bit ^ s_bit));endmodule