module top_module(
    input A,
    input B,
    input CI,
    output SUM,
    output CO
);assign SUM = A ^ B ^ CI;  // Sum logic
    assign CO = (A & B) | (B & CI) | (A & CI);  // Carry out logic
endmodule