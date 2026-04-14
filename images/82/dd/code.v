module top_module(m_out,x_in,y_in,sel);output m_out;
    input x_in,y_in,sel;
    wire s_not,m1,m2;
    not s1(s_not,sel);
    and and1(m1,s_not,x_in);
    and and2(m2,sel,y_in);
    or or1(m_out,m1,m2);
endmodule