module top_module(
    input wire    [1:0]     selector,
    input wire    [31:0]    Data_0,
    input wire    [31:0]    Data_1,
    input wire    [31:0]    Data_2,
    input wire    [31:0]    Data_3,
    output wire   [31:0]    Data_out
);assign Data_out = selector[1] ? (selector[0] ? Data_0 : Data_1) : (selector[0] ? Data_2 : Data_3);


    
endmodule