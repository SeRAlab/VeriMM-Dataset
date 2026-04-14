module top_module(
    input clk,
    input reset, // Synchronous active-high reset
    input [7:0] a, // 8-bit input for selection port a
    input [7:0] b, // 8-bit input for selection port b
    input sel_b1, // Select input for port b MSB
    input sel_b2, // Select input for port b LSB
    output reg [7:0] q // 8-bit output from the last DFF in the shift register
);reg [7:0] shift_reg; // 8-bit shift register
    reg [7:0] mux_out; // Output of the 2-to-1 multiplexer
    
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 8'd0; // Reset the shift register to 0x00
            mux_out <= a; // Select input a
        end else begin
            // Shift the shift register
            shift_reg <= {shift_reg[6:0], shift_reg[7]};
            
            // Load the input into the shift register
            if (sel_b1 && sel_b2) begin
                mux_out <= shift_reg; // Select the output of the shift register
            end else if (sel_b1) begin
                mux_out <= {b[6:0], b[7]}; // Select input b shifted left by 1 bit
            end else if (sel_b2) begin
                mux_out <= {b[5:0], b[7:6]}; // Select input b shifted left by 2 bits
            end else begin
                mux_out <= a; // Select input a
            end
            
            // Load the LSB of the mux output into the shift register
            shift_reg[0] <= mux_out[0];
        end
    end
    
    assign q = shift_reg[7]; // Output the MSB of the shift register
    
endmodule