module top_module(
    input [31:0] u,
    output [8:0] y
);wire [8:0] y1;
    
    assign y1 = u[17:9];
    assign y = y1;
    
endmodule