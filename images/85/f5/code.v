module top_module(
    y,
    a1,
    a2,
    a3,
    b1,
    vpwr,
    vgnd,
    vpb,
    vnb
);output y;
    input [3:0] a1, a2, a3, b1;
    input vpwr, vgnd, vpb, vnb;

    wire [4:0] sum;
    assign sum = a1 + a2 + a3 + b1;

    wire greater_than_or_equal_to_10;
    assign greater_than_or_equal_to_10 = (sum >= 10);

    assign y = (greater_than_or_equal_to_10) ? 1 : 0;

endmodule