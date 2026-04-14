module xor_module(
    input a,
    input b,
    output out_comb_logic
);
    
    assign out_comb_logic = a ^ b;
    
endmodule