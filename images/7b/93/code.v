module top_module(
    input clk,
    input reset,       // Synchronous active-high reset
    input [31:0] a, b, // Inputs to the adder
    output [31:0] out  // Output from the functional module
);// 32-bit adder
    wire [31:0] adder_out;
    assign adder_out = a + b;
    
    // Parity checker
    reg [31:0] parity_reg;
    wire parity_check;
    assign parity_check = ^parity_reg;
    
    always @(posedge clk) begin
        if (reset) begin
            parity_reg <= 0;
        end else begin
            parity_reg <= parity_reg ^ adder_out;
        end
    end
    
    // Functional module
    assign out = parity_reg - adder_out;
    
endmodule