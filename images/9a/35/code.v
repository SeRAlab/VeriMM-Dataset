module top_module(
    input clk, 
    input a, 
    input b,
    output reg q
);wire sum;
    wire carry_out;
    wire final_output;
    
    // Half adder
    xor(sum, a, b);
    and(carry_out, a, b);
    
    // D flip-flop
    reg d;
    always @(posedge clk) begin
        d <= sum;
    end
    
    // Final output
    or(final_output, carry_out, q);
    
    // Output
    assign q = final_output;
    
endmodule