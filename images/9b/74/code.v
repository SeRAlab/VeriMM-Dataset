module top_module(
    input A1,
    input A2,
    input B1,
    input C1,
    input D1,
    output Y
);// Combinational logic
    assign Y = (A1 & A2) ? B1 : (A2 ? C1 : (A1 ? D1 : 1'b0));

endmodule