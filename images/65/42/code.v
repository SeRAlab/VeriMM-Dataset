module top_module(
    input clk,
    input d,
    input [3:0] delay,
    output reg q  // Change q from wire to reg to allow assignment in always block
);reg [2:0] shift_reg;
reg [3:0] delay_counter;

always @(posedge clk) begin
    // Shift the register
    shift_reg <= {shift_reg[1:0], d};
    
    // Update the delay counter
    if (delay_counter == delay) begin
        // Output the delayed value
        q <= shift_reg[2];
    end else begin
        // This prevents q from being unassigned in some cases
        q <= q; // Hold the value of q if delay condition is not met
    end
    delay_counter <= delay_counter + 1;
end

endmodule