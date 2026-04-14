module top_module(
    input input_a,
    input input_b,
    input input_c,
    output output_x,
    input vpwr,
    input vgnd
);wire or1_output;
    wire or2_output;
    wire or3_output;
    
    // instantiate 3-input OR gates using logical or
    assign or1_output = input_a | input_b | input_c;

    assign or2_output = input_a | input_b | or1_output;
    
    assign or3_output = or2_output | input_c | or1_output;
    
    // invert the output of the final OR gate to get the correct output
    assign output_x = ~or3_output;
    
endmodule