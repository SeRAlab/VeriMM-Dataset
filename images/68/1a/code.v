module top_module(rx, tx, rxLEDout, txButtonIn, txLEDout);input rx, txButtonIn;
output tx, rxLEDout, txLEDout;


assign rxLEDout = rx;


assign tx = txButtonIn;
assign txLEDout = txButtonIn;

endmodule