module top_module(
    output Y,
    input  A,
    input  B,
    input  C,
    input  D
);wire n1, n2, n3, n4, n5;

    // Implementing a NOR3 gate behavior
    function nor3(input A, input B, input C);
        begin
            nor3 = ~(A | B | C);
        end
    endfunction
    
    assign n1 = nor3(A, B, C);
    assign n2 = nor3(B, C, D);
    assign n3 = nor3(A, C, D);
    assign n4 = nor3(A, B, D);
    
    assign n5 = nor3(n1, n2, n3);
    assign Y = nor3(n5, n4, D);

endmodule