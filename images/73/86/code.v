module top_module(
    input clk,
    input [2:0] a,
    input [2:0] b,
    input [7:0] reset,      // Asynchronous reset
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [7:0] q
);// Combinational logic circuit for OR operation
    wire [2:0] or_output;
    assign or_output = a | b;
    
    // D flip-flop module with asynchronous reset
    reg [7:0] d_ff_output;
    always @(negedge clk) begin
        if (reset[0]) d_ff_output[0] <= 1'b0;
        else d_ff_output[0] <= or_output[0];
        
        if (reset[1]) d_ff_output[1] <= 1'b0;
        else d_ff_output[1] <= or_output[1];
        
        if (reset[2]) d_ff_output[2] <= 1'b0;
        else d_ff_output[2] <= or_output[2];
        
        if (reset[3]) d_ff_output[3] <= 1'b0;
        else d_ff_output[3] <= or_output[2];
        
        if (reset[4]) d_ff_output[4] <= 1'b0;
        else d_ff_output[4] <= or_output[2];
        
        if (reset[5]) d_ff_output[5] <= 1'b0;
        else d_ff_output[5] <= or_output[2];
        
        if (reset[6]) d_ff_output[6] <= 1'b0;
        else d_ff_output[6] <= or_output[2];
        
        if (reset[7]) d_ff_output[7] <= 1'b0;
        else d_ff_output[7] <= or_output[2];
    end
    
    // Functional module for AND operation
    wire and_output;
    assign and_output = &d_ff_output & or_output;
    
    // Output assignments
    assign out_or_bitwise = or_output;
    assign out_or_logical = |or_output;
    assign q = d_ff_output;
    assign q[7] = and_output;
    
endmodule