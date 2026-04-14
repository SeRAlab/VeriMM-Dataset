module top_module(
    input clk, 
    input rst, 
    input load_enable, 
    input write_enable,
    input [1:0] adr,
    input bit_in,  // Changed input name to avoid conflict with Verilog bit type
    output reg [3:0] foo_out
);reg [3:0] foo;
    reg [3:0] bar;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            foo <= 4'b0000; // Initialize foo with a 4-bit value
        end else if (load_enable) begin
            foo <= bar; // Here foo is loaded with the value of bar
        end else if (write_enable) begin
            foo[adr] <= bit_in; // Store the value of bit_in into foo at address adr
        end
    end

    assign foo_out = foo; // Assign the value of foo to foo_out

endmodule