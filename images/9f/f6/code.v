module top_module( 
    PADP, 
    PADN, 
    Y );/* synthesis syn_black_box */
/* synthesis black_box_pad_pin ="PADP, PADN" */

    input  PADP;
    input  PADN;
    output Y;

parameter ACT_PIN    = "";

    assign Y = PADP ^ PADN;

endmodule