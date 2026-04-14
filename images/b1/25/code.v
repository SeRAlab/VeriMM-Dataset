module top_module(
    input clk,
    input reset,
    input [31:0] in,
    input select,
    output [31:0] out,
    output [0:0] high_input
);reg [31:0] reg_out;
    wire [31:0] shifted_in;
    wire [0:0] greater_than_100;
    
    // Register with active low synchronous reset
    always @(posedge clk, negedge reset) begin
        if (!reset) begin
            reg_out <= 0;
        end else begin
            reg_out <= select ? shifted_in : in;
        end
    end
    
    // Logical shift right by 4 bits
    assign shifted_in = in >> 4;
    
    // Check if input is greater than or equal to 100
    assign greater_than_100 = in >= 100;
    
    // Output
    assign out = reg_out;
    assign high_input = greater_than_100;
    
endmodule