module top_module(
    input [31:0] select_0,
    input [31:0] select_1,
    input [31:0] select_2,
    input [1:0] selection,
    output [31:0] OutAddress
    );assign OutAddress = (selection === 2'b00 ? select_0 : 
                        (selection === 2'b01 ? select_1 : select_2));
endmodule