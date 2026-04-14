module top_module(
    input clk,
    input d,
    input enable,
    output reg q
);parameter WIDTH = 4; // Set the width of the shift register and ring counter

reg [WIDTH-1:0] shift_reg; // Declare the shift register
reg [WIDTH-1:0] ring_counter; // Declare the ring counter

always @(posedge clk) begin
    if (enable) begin
        // Shift the values in the shift register to the left
        shift_reg <= {shift_reg[WIDTH-2:0], d};
        
        // Increment the ring counter
        ring_counter <= ring_counter + 1;
        
        // Output the value in the final stage of the shift register
        q <= shift_reg[WIDTH-1];
    end
end

endmodule