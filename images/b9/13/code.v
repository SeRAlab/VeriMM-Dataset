module top_module(
    input clk, // Clock signal
    input reset, // Synchronous active-high reset
    input [7:0] a, b, // 8-bit input values
    output reg [7:0] result // 8-bit output representing the multiplication result
);reg [7:0] product; // 8-bit register to store the product
    reg [7:0] quotient; // 8-bit register to store the quotient
    
    // Multiplication module
    always @(posedge clk) begin
        if (reset) begin
            product <= 8'b0; // Reset the product register
        end else begin
            product <= a * b; // Perform multiplication
        end
    end
    
    // Division by 2 module
    always @(posedge clk) begin
        if (reset) begin
            quotient <= 8'b0; // Reset the quotient register
        end else begin
            quotient <= product >> 1; // Perform division by 2
        end
    end
    
    // Assign output
    assign result = quotient;

endmodule