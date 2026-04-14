module top_module(
    output Y,
    input A1,
    input A2,
    input B1,
    input C1,
    input D1
);wire a_and = A1 & A2;
    wire b_or = B1 | C1 | D1;
    
    assign Y = a_and | b_or;

endmodule