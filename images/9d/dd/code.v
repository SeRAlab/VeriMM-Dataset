module top_module(
    input m_ctlout,
    input zero,
    output PCSrc);assign PCSrc = zero && m_ctlout;
endmodule