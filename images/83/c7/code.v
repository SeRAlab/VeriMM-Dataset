module top_module(
    input [2:0] a,
    input [2:0] b,
    input sel_b1,
    input sel_b2,
    input clk,  // Added clk input signal
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);// Shift register to store inverted input values
    reg [5:0] inverted_input_reg;
    
    // Combinational circuit for bitwise-OR and logical-OR operations
    wire [2:0] or_bitwise = a | b;
    wire or_logical = (a != 0) || (b != 0);
    
    // 2-to-1 multiplexer to select between bitwise-OR and logical-OR operations
    wire [2:0] selected_output;
    assign selected_output = sel_b1 ? {or_logical, 2'b00} : or_bitwise; // Fixed type mismatch, or_logical is 1-bit
    
    // Invert selected output and store in upper half of out_not
    assign out_not[5:3] = ~selected_output;
    
    // Store non-inverted selected output in lower half of out_not
    assign out_not[2:0] = selected_output;
    
    // Output selected output to out_or_bitwise
    assign out_or_bitwise = selected_output;
    
    // Output or_logical to out_or_logical
    assign out_or_logical = or_logical;
    
    // Shift inverted input values and store new inverted input value
    always @(posedge clk) begin
        inverted_input_reg <= {inverted_input_reg[4:0], ~{a,b}}; // Ensure storage is allocated to the correct size
    end
    
endmodule