module top_module(
    input clk,
    input d,
    input reset,
    output [3:0] counter_q,
    output xor_output
);// Define the shift register using JK flip-flops
    reg [2:0] shift_register;
    always @(posedge clk) begin
        shift_register <= {shift_register[1:0], d};
    end
    
    // Define the binary counter using combinational logic
    wire [3:0] counter_q_temp;
    assign counter_q_temp = (reset) ? 4'b0000 : counter_q + 1;
    
    // Define the output of the last flip-flop as the input to the binary counter
    wire counter_input;
    assign counter_input = shift_register[2];
    
    // Define the output of the binary counter as counter_q
    assign counter_q = counter_q_temp[3:0];
    
    // Define the XOR output module using the shift register and the binary counter
    assign xor_output = shift_register ^ counter_q_temp;
    
endmodule