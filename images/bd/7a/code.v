module top_module(
    input clk,
    input [2:0] counter_in, // Input to the counter module
    input Up_Down, // Control input to choose between up and down count
    input Reset, // Synchronous active-high reset
    output reg [4:0] result // Output from the next_power_of_two module
);reg [2:0] counter_out; // Output from the counter module
    wire [4:0] next_power; // Output from the next_power_of_two module
    
    // Counter module. Add definition here if not available in another file.
    always @(posedge clk) begin
        if (Reset) begin
            counter_out <= 0;
        end
        else if (Up_Down) begin
            if (counter_out < 3'b111) // Prevent overflow
                counter_out <= counter_out + 1;
        end
        else begin
            if (counter_out > 0) // Prevent underflow
                counter_out <= counter_out - 1;
        end
    end
    
    // Next Power Of Two module. Add definition here if not available in another file.
    function [4:0] next_power_of_two;
        input [2:0] in;
        begin
            next_power_of_two = 1 << (in == 0 ? 0 : (in - 1)); // Calculate next power of two
        end
    endfunction

    always @ (posedge clk) begin
        if (Reset) begin
            result <= 1;
        end
        else begin
            result <= next_power_of_two(counter_out);
        end
    end
    
endmodule