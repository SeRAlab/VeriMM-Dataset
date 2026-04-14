module data_control(
    input [15:0] data_in,
    input [3:0] control_in,
    output [15:0] data_out,
    output [3:0] control_out
);

assign data_out = data_in + 1;
assign control_out = control_in << 1;

endmodule