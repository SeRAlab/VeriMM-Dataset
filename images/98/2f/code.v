module top_module(
    input [3:0] D,
    output [2:0] Q
);wire [1:0] subtract;
    
    assign subtract = D[3:2] - 2'b11;
    
    assign Q = (D <= 4'b0111) ? D[2:0] : subtract;

endmodule