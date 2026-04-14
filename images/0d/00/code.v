module simple_nn (
    input wire clk,
    input wire rst,
    input wire [7:0] input1,
    input wire [7:0] input2,
    output reg output1
);

    // Define weights as parameters
    parameter W1 = 8'd2; // Weight for input1 to hidden1
    parameter W2 = 8'd3; // Weight for input1 to hidden2
    parameter W3 = 8'd1; // Weight for input2 to hidden1
    parameter W4 = 8'd2; // Weight for input2 to hidden2
    parameter W5 = 8'd4; // Weight for hidden1 to output
    parameter W6 = 8'd1; // Weight for hidden2 to output
    
    reg [15:0] hidden1, hidden2, net_output;

    // Step function
    function [0:0] step;
        input [15:0] x;
        begin
            step = (x > 0) ? 1'b1 : 1'b0;
        end
    endfunction

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            hidden1 <= 16'd0;
            hidden2 <= 16'd0;
            net_output <= 16'd0;
            output1 <= 1'b0;
        end else begin
            // Calculate hidden layer activations
            hidden1 <= step((input1 * W1) + (input2 * W3));
            hidden2 <= step((input1 * W2) + (input2 * W4));

            // Calculate output neuron activation
            net_output <= (hidden1 * W5) + (hidden2 * W6);
            output1 <= step(net_output);
        end
    end
endmodule