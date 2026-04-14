module top_module(
    input [3:0] data_in,
    input [1:0] ctrl,
    output [3:0] data_out
);assign data_out = (ctrl == 2'b00) ? 4'b0000 :
                      (ctrl == 2'b01) ? 4'b1111 :
                      (ctrl == 2'b10) ? data_in :
                      ~data_in;

endmodule