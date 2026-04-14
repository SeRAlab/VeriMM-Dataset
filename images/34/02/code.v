module neuron(
    input wire x1,
    input wire x2,
    input wire x3,
    output wire y
);
    wire [3:0] weighted_sum;
    
    assign weighted_sum = (1 * x1) + (2 * x2) + (3 * x3);
    assign y = (weighted_sum >= 4) ? 1 : 0;
endmodule