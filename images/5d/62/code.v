module top_module(
    input wire clk, coin, button1, button2,
    output reg dispense1, dispense2
);reg [3:0] count1 = 10; // initialize with 10 products
    reg [3:0] count2 = 10; // initialize with 10 products
    reg coin_inserted;

    always @(posedge clk) begin
        if (coin) begin
            coin_inserted <= 1;
        end
        if (button1 && coin_inserted && count1 > 0) begin
            count1 <= count1 - 1;
            dispense1 <= 1;
        end
        if (button2 && coin_inserted && count2 > 0) begin
            count2 <= count2 - 1;
            dispense2 <= 1;
        end
        if (dispense1) begin
            dispense1 <= 0;
        end
        if (dispense2) begin
            dispense2 <= 0;
        end
        if (!button1 && !button2) begin
            coin_inserted <= 0;
        end
    end

endmodule