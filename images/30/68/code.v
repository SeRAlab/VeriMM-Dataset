module mux4to1 (
    input wire input0,
    input wire input1,
    input wire input2,
    input wire input3,
    input wire [1:0] sel,
    output wire out
);
    assign out = (sel == 2'b00) ? input0 :
                 (sel == 2'b01) ? input1 :
                 (sel == 2'b10) ? input2 :
                 input3;  // sel == 2'b11
endmodule