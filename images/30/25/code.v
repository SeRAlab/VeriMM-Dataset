module data_forwarding_unit (
    input [3:0] in0,
    input [3:0] in1,
    input select,
    output [3:0] out
);
    assign out = (select) ? in1 : in0;
endmodule