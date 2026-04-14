module top_module( 
    input wire [15:0] in,
    input wire enable,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo,
    output reg [2:0] shift_out // Changed wire to reg
);// Shift Register
    reg [2:0] shift_reg;
    always @ (enable)
        if (enable)
            shift_reg <= {shift_reg[1:0], in[0]};
    
    // Barrel Shifter
    assign out_hi = in[15:8];
    assign out_lo = in[7:0];
    
    // Functional Module
    always @ (shift_reg, out_lo) // update to use procedural block for output reg
        shift_out = shift_reg | out_lo[2:0]; // Ensure proper width

endmodule