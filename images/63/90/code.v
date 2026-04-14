module top_module(
    input clk,
    input reset,
    input coin,
    input item,
    output reg dispense,  // Changed to reg
    output reg change     // Changed to reg
);parameter ITEM_COST = 25; // cost in cents
    parameter COIN_VALUE = 25; // value in cents
    parameter MAX_ITEMS = 10;

    reg [3:0] state;
    reg [3:0] count;
    reg [3:0] item_count;

    // state definitions
    parameter IDLE = 4'b0000;
    parameter COIN_INSERTED = 4'b0001;
    parameter ITEM_SELECTED = 4'b0010;
    parameter DISPENSING = 4'b0011;
    parameter CHANGE_DISPENSING = 4'b0100;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= IDLE;
            count <= 0;
            item_count <= MAX_ITEMS;
            dispense <= 0;
            change <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (coin && count == 0) begin
                        count <= 1;
                        state <= COIN_INSERTED;
                    end
                end
                COIN_INSERTED: begin
                    if (coin && count < 2) begin
                        count <= count + 1;
                    end else if (!coin && count == 2) begin
                        count <= 0;
                        state <= ITEM_SELECTED;
                    end
                end
                ITEM_SELECTED: begin
                    if (item_count > 0) begin
                        item_count <= item_count - 1;
                        state <= DISPENSING;
                    end else begin
                        state <= IDLE;
                    end
                end
                DISPENSING: begin
                    dispense <= 1;
                    state <= CHANGE_DISPENSING;
                end
                CHANGE_DISPENSING: begin
                    change <= 1;
                    state <= IDLE;
                end
                default: begin
                    dispense <= 0;
                    change <= 0; // Reset outputs in default case
                end
            endcase
        end
    end

endmodule