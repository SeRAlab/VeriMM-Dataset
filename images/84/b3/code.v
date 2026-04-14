module top_module(input A, input B, input C, input D, output Z);assign Z = (A & ~B) ? 1 : ((~A & B) ? 0 : ((A & B) ? C : D));
    
endmodule