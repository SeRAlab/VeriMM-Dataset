module top_module(
    input A,
    input B,
    input C,
    output Y
);wire AB;
wire BC;
wire Y1;

// Replacing missing nor2 and not2 module types with equivalent NOR gates and NOT gates
wire Y_nor1, Y_nor2, Y_nor3;
assign Y_nor1 = ~(A | B); // Implementing NOR using NOT and OR
assign Y_nor2 = ~(B | C); // Implementing NOR using NOT and OR
assign Y_nor3 = ~(Y_nor1 | Y_nor2); // Implementing NOR using NOT and OR
assign Y = ~Y_nor3; // Final output Y (NOT of Y_nor3)

endmodule