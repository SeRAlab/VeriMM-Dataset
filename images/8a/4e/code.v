module top_module(input [7:0] a,b, output reg [7:0] match);integer i;
    wire ab_xor;
    always @(a or b) begin
        for (i=7; i>=0; i=i-1) begin
            match[i] = ~(a[i]^b[i]);
        end
    end
endmodule