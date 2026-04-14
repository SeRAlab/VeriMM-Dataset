module data_forwarding (
    input [4:0] data1,
    input [4:0] data2,
    input sel,
    output [4:0] out
);
    assign out = (sel) ? data2 : data1;
endmodule