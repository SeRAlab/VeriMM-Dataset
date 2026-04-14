module simple_neuron(
    input [4:0] weights, // 5 binary inputs representing weights
    output reg output_signal // output of the neuron
);
    always @* begin
        if (weights[0] + weights[1] + weights[2] + weights[3] + weights[4] >= 3) 
            output_signal = 1; 
        else 
            output_signal = 0; 
    end
endmodule