module dwt_haar (
    input [15:0] data_in,  // 4x4 input matrix flatten into a 16-bit input
    output [15:0] approx_out,  // 4x4 approximation matrix flatten into a 16-bit output
    output [15:0] detail_out   // 4x4 detail matrix flatten into a 16-bit output
);

    wire [3:0] a0, a1, a2, a3;  // Approximation coefficients
    wire [3:0] d0, d1, d2, d3;  // Detail coefficients
    
    // Haar transform - horizontal
    assign a0 = (data_in[3:0] + data_in[7:4]) >> 1;  // Average
    assign a1 = (data_in[11:8] + data_in[15:12]) >> 1;  // Average
    assign d0 = (data_in[3:0] - data_in[7:4] + 1) >> 1;  // Detail
    assign d1 = (data_in[11:8] - data_in[15:12] + 1) >> 1;  // Detail
    
    // Haar transform - vertical
    assign approx_out[3:0] = (a0 + a1) >> 1;
    assign approx_out[7:4] = a0 - a1; 
    assign approx_out[11:8] = (d0 + d1) >> 1;
    assign approx_out[15:12] = d0 - d1;

    assign detail_out[3:0] = a0; 
    assign detail_out[7:4] = d0; 
    assign detail_out[11:8] = a1; 
    assign detail_out[15:12] = d1; 

endmodule