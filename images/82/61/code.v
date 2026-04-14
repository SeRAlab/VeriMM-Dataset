module top_module(
    input a,
    input b,
    input c,
    output reg y
);wire ab;
    wire abc;
    
    assign ab = a & b;
    assign abc = ab & c;
    
    always @(abc) begin
        y = abc;
    end

endmodule