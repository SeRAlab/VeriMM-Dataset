module top_module(
    input clk,
    input en,
    input async_clear,
    output reg [5:0] counter
);

    // Always block triggered on the rising edge of the clock or on async_clear
    always @(posedge clk or posedge async_clear) begin
        if (async_clear) begin
            counter <= 6'b0;  // Asynchronous clear to zero
        end else if (en) begin
            counter <= counter + 1;  // Increment the counter
        end
    end

endmodule