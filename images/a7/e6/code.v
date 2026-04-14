module top_module(
    input wire clk,
    input wire reset,
    output reg led3, // changed to reg
    output reg led2, // changed to reg
    output reg led1, // changed to reg
    output reg led0  // changed to reg
);reg [3:0] counter; // 4-bit register to hold the counter value

    // always block to increment the counter and update the LED outputs
    always @(posedge clk) begin
        if (reset) begin
            counter <= 4'b0; // reset the counter to zero
        end else begin
            counter <= counter + 1; // increment the counter
        end
        // update the LED outputs with the counter value
        led3 <= counter[3];
        led2 <= counter[2];
        led1 <= counter[1];
        led0 <= counter[0];
    end
    
endmodule