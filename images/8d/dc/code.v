module top_module(
    input clk,
    input reset,     // Synchronous active-high reset
    input [7:0] d,   // 8-bit input for the shift register
    input select,    // Select input for shifting left or right
    output reg [7:0] q,  // 8-bit output from the shift register
    output reg [3:0] ena,// Incrementer enable signal for each digit
    output reg [3:0] c,  // Incrementer output for each digit
    output [7:0] f    // Output from the functional module
);reg [7:0] shift_reg;
reg [3:0] counter;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 8'b0;
        counter <= 4'b0;
        ena <= 4'b0; // Initialize ena on reset
        c <= 4'b0;   // Initialize c on reset
    end else begin
        if (select) begin
            shift_reg <= {shift_reg[6:0], d[0]}; // Note: change from d to d[0] assuming moving in single bit form
        end else begin
            shift_reg <= {d[7], shift_reg[7:1]}; // Note: change from d to d[7] assuming moving in single bit form
        end
        
        ena <= 4'b1111; // Assign enable signal
        c <= counter; // Assign counter value
        counter <= counter + 1;
        if (counter == 4'b1111) begin
            counter <= 4'b0; // Reset counter on overflow
        end
    end
end

assign q = shift_reg;
assign f = shift_reg ^ {counter, counter, counter, counter};

endmodule