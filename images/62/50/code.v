module top_module(
    input sleep,
    input vpwr,
    input vgnd,
    output pwrgood
);assign pwrgood = (!sleep && vpwr && vgnd);

endmodule