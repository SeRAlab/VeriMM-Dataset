module top_module(
    input [15:0] A,
    input [15:0] B,
    output reg [15:0] sum,
    input [3:0] in,
    output [15:0] out
);wire [15:0] add_result;
    wire [15:0] complement_out;
    
    // 16-bit signed magnitude adder
    assign add_result = A + B;
    assign sum = (add_result[15] == 1) ? -add_result : add_result;
    
    // 4-to-16 decoder with active-low outputs
    assign out = ~{in[3], in[2], in[1], in[0]};
    
    // Complement of decoder output
    assign complement_out = ~out;
    
endmodule