module top_module(
    Y,
    A
);output Y;
    input  [11:0] A;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    wire [11:0] inverted_inputs;
    
    // Generate inverted inputs
    assign inverted_inputs = ~A;
    
    // Generate output
    assign Y = inverted_inputs[11] & inverted_inputs[10] & inverted_inputs[9] & inverted_inputs[8] & inverted_inputs[7] & inverted_inputs[6] & inverted_inputs[5] & inverted_inputs[4] & inverted_inputs[3] & inverted_inputs[2] & inverted_inputs[1] & inverted_inputs[0];

endmodule