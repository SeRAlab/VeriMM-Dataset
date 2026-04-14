module fir_filter (
    input [3:0] x0, // Current input sample
    input [3:0] x1, // Previous input sample
    input [3:0] x2, // Two samples back
    input [3:0] x3, // Three samples back
    output reg [7:0] y // Filter output
);
    always @(*) begin
        y = (1*x0) + (2*x1) + (3*x2) + (4*x3);
    end
endmodule