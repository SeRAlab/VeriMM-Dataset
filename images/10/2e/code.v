module DWT (
    input [3:0] a,
    output reg [3:0] c0,
    output reg [3:0] d0,
    output reg [3:0] c1,
    output reg [3:0] d1
);
    always @(*) begin
        c0 = (a[3:2] + a[1:0]) >> 1; // Approximation Coefficient for first pair
        d0 = (a[3:2] - a[1:0]) >> 1; // Detail Coefficient for first pair
        c1 = (a[1:0] + a[3:2]) >> 1; // Approximation Coefficient for second pair
        d1 = (a[1:0] - a[3:2]) >> 1; // Detail Coefficient for second pair
    end
endmodule