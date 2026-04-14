module mux_4to1 (
    input [1:0] select,
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    output [3:0] data_out );assign data_out = (select == 2'b00) ? data0 :
                  (select == 2'b01) ? data1 :
                  (select == 2'b10) ? data2 :
                                      data3;

endmodule