module fir_filter (
    input [3:0] x,      // 4-bit input
    output [7:0] y      // 8-bit output
);
    parameter [3:0] h0 = 4'b0001;
    parameter [3:0] h1 = 4'b0010;
    parameter [3:0] h2 = 4'b0011;
    parameter [3:0] h3 = 4'b0100;
    
    assign y = (x * h0) + (x * h1) + (x * h2) + (x * h3);
endmodule