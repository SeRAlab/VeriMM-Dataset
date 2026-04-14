module top_module(
    input clk,
    input reset,
    input [31:0] in,
    output [3:0] out
);// Rising edge detector module from problem 1
    reg prev_clk;
    reg rising_edge; // Change 'wire' to 'reg' for rising_edge
    always @(posedge clk) begin
        prev_clk <= clk;
        rising_edge <= (prev_clk == 1'b0) && (clk == 1'b1);
    end
    
    // Shift register module from problem 2
    reg [3:0] shift_reg;
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
        end else if (rising_edge) begin
            shift_reg <= {in[3:0], shift_reg[3:1]}; // Ensure only 4 bits from 'in' are used
        end
    end
    
    // Bitwise AND module with constant value of 0x0F
    wire [3:0] and_result;
    assign and_result = shift_reg & 4'hF;
    
    // Output
    assign out = and_result;
    
endmodule