module top_module(a, b, prod);parameter DATAWIDTH = 64;

    input [DATAWIDTH - 1:0] a, b;
    output reg [DATAWIDTH - 1:0] prod;
    
    always @(*) begin
    
        prod <= a * b;
    
    end
    
endmodule