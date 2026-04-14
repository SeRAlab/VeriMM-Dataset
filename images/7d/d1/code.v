module top_module(
    input [3:0] data_i,
    output data_o
    );wire [1:0] tmp1;
    
    assign tmp1 = data_i[1:0] | data_i[3:2];
    assign data_o = tmp1[0] | tmp1[1];endmodule