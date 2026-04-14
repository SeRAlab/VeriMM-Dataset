module top_module(
    clk,
    data_in,
    scd,
    sce,
    vpwr,
    vgnd,
    vpb,
    vnb,
    data_out
);input clk;
    input data_in;
    input scd;
    input sce;
    input vpwr;
    input vgnd;
    input vpb;
    input vnb;
    output data_out;

    wire select_1;
    wire select_2;
    wire select_3;
    wire select_4;

    assign select_1 = ~scd & ~sce;
    assign select_2 = scd & ~sce;
    assign select_3 = ~scd & sce;
    assign select_4 = scd & sce;

    assign data_out = select_1 ? 1'b0 :
                      select_2 ? data_in :
                      select_3 ? ~data_in :
                      select_4 ? 1'b1 :
                      1'bx;

endmodule