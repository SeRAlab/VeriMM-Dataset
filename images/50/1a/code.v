module top_module(

    RX_STATUS,
    CHANNEL_BOND_LOAD,
    USER_CLK

);`define DLY #1



    parameter CHANNEL_BOND_LOAD_CODE = 6'b100111;  




    input   [5:0]   RX_STATUS;
    output          CHANNEL_BOND_LOAD;

    input           USER_CLK;




    reg             CHANNEL_BOND_LOAD;



    always @(posedge USER_CLK)
        CHANNEL_BOND_LOAD <= (RX_STATUS == CHANNEL_BOND_LOAD_CODE);

endmodule