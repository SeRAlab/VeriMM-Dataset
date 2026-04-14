module piso_shift_reg_4bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal.
    input load,         // Load signal to load the parallel data.
    input [3:0] pdata,  // 4-bit parallel input data.
    
    output sdata        // Serial output data.
);

reg [3:0] shift_reg;

//------------------------------------------------
// Shift register logic
always @(posedge clk or negedge rst_n)
    if (!rst_n) shift_reg <= 4'd0;  // Reset shift register
    else if (load) shift_reg <= pdata; // Load parallel data
    else shift_reg <= {1'b0, shift_reg[3:1]}; // Shift right

assign sdata = shift_reg[0]; // Output the least significant bit

endmodule