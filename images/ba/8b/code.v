module top_module(
    input clk,      // Clock input
    input reset,    // Synchronous active-high reset
    input [7:0] d,  // 8-bit input for the shift register
    input [31:0] in, // 32-bit input for the rising edge capture module
    output [31:0] out // 32-bit output from the functional module
);reg [7:0] shift_reg [3:0]; // 4-stage shift register
reg [31:0] capture_reg; // Rising edge capture register
reg [31:0] product; // Product of shift register and capture register

always @(posedge clk) begin
    if (reset) begin
        // Reset all registers to 0
        shift_reg[0] <= 8'b0;
        shift_reg[1] <= 8'b0;
        shift_reg[2] <= 8'b0;
        shift_reg[3] <= 8'b0;
        capture_reg <= 32'b0;
        product <= 32'b0;
    end else begin
        // Shift register
        shift_reg[0] <= d;
        shift_reg[1] <= shift_reg[0];
        shift_reg[2] <= shift_reg[1];
        shift_reg[3] <= shift_reg[2];
        
        // Rising edge capture
        capture_reg <= {capture_reg[30:0], in[31]};
        
        // Functional module: multiply shift register and capture register
        product <= shift_reg[3] * capture_reg;
    end
end

assign out = product;

endmodule