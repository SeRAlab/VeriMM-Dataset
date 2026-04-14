module top_module( output s,
                         input [0:7] p);wire temp0 , temp1, temp2, temp3, temp4, temp5, temp6, temp7; 
or OR0 (temp0, p[0], p[1]);
or OR1 (temp1, temp0, p[2]);
or OR2 (temp2, temp1, p[3]);
or OR3 (temp3, temp2, p[4]);
or OR4 (temp4, temp3, p[5]);
or OR5 (temp5, temp4, p[6]);
or OR6 (temp6, temp5, p[7]);


assign s = temp6;endmodule