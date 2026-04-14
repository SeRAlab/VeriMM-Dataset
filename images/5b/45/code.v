module top_module( 
    input clk, 
    input reset,      // Synchronous active-high reset
    input a,           // Input for the shift register
    input b,           // Input for the shift register
    output out         // Output from the functional module
);// Define the shift register module
    reg [7:0] shift_reg;
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 8'h34;
        end else begin
            shift_reg <= {shift_reg[6:0], a};
        end
    end
    
    // Define the XOR module
    wire xor_out = a ^ b;
    
    // Define the functional module
    assign out = shift_reg & xor_out;

endmodule