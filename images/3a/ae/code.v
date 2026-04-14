module simple_neuron (
    input [7:0] x1,
    input [7:0] x2,
    input [7:0] x3,
    output [7:0] y
);
    parameter w1 = 2;
    parameter w2 = -1;
    parameter w3 = 3;
    parameter b = 1;
    
    assign y = (w1 * x1) + (w2 * x2) + (w3 * x3) + b;
endmodule