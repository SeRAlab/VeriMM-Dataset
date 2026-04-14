module shift_register_4bit(
    input clk,    // Chip clock signal.
    input load,   // Parallel load signal.
    input [3:0] pdata,  // 4-bit parallel data input.
    input d,      // Serial input data signal.
    
    output reg [3:0] q  // 4-bit output data signal.
);

//------------------------------------------------
// 4-bit shift register logic
always @(posedge clk)
    if (load) q <= pdata;  // Load parallel data
    else q <= {q[2:0], d}; // Shift serial data

endmodule