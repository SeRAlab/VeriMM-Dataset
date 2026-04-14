module barrel_shifter (
    input [1:0] input_data,
    input shift_dir,
    output [1:0] output_data
);
    assign output_data = (shift_dir == 1'b0) ? {input_data[0], input_data[1]} : {input_data[1], input_data[0]};
endmodule