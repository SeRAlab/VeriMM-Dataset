module top_module(
    A,
    B,
    C,
    D,
    sel,
    Y
);// Module ports
    input  A;
    input  B;
    input  C;
    input  D;
    input  [1:0] sel;
    output Y;

    // Assign output Y based on the select signal
    assign Y = (sel == 2'b00) ? A : 
               (sel == 2'b01) ? B : 
               (sel == 2'b10) ? C : 
                                D;

endmodule