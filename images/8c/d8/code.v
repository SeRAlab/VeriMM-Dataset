module top_module(
    input wire clock, // Added clock input
    input wire reset,
    input wire coin,
    input wire dispense,
    output reg item_dispensed,
    output reg [2:0] change // Change should be a 3-bit output
);parameter ITEM_PRICE = 4; // price of the item in quarters

reg [1:0] state; // state variable
reg [2:0] count; // count of quarters received

// state definitions
parameter IDLE = 2'b00;
parameter DISPENSE = 2'b01;

always @(posedge clock) begin
    if (reset) begin
        // reset state
        state <= IDLE;
        count <= 0;
        item_dispensed <= 0;
        change <= 0;
    end else begin
        // idle state
        if (state == IDLE) begin
            if (coin) begin
                count <= count + 1;
            end
            if (dispense && count >= ITEM_PRICE) begin
                state <= DISPENSE;
            end
        end
        // dispense state
        else if (state == DISPENSE) begin
            item_dispensed <= 1;
            change <= count - ITEM_PRICE;
            state <= IDLE;
        end
    end
end

endmodule