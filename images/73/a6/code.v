module top_module(
    input [3:0] keypad_in, // Input from the keypad, 4 digits
    input clk,
    input reset,
    output reg unlocked // Output to control the lock's unlocking mechanism
);// Define the correct code
parameter [3:0] CORRECT_CODE = 4'h4; // Correct code for the lock

// Internal signal to store the temporary code
reg [3:0] entered_code;

// Reset the lock to be locked initially
always @(posedge clk or posedge reset) begin
    if (reset) begin
        unlocked <= 1'b0;
        entered_code <= 4'b0000; // Reset entered code
    end else begin
        entered_code <= keypad_in; // Update entered code with keypad input
        if (entered_code == CORRECT_CODE) begin
            unlocked <= 1'b1; // Unlock if correct code is entered
        end else begin
            unlocked <= 1'b0; // Remain locked otherwise
        end
    end
end

endmodule