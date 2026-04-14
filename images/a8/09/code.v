module top_module(
    input wire[31:0] x,
    output wire[31:0] y
    );assign y = {x[29:0], 2'b00}; 
endmodule