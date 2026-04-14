module top_module(
    input clk,
    input rst,
    input quarter,
    input dime,
    input nickel,
    output reg skittles_dispense,
    output reg mms_dispense,
    output reg reeses_dispense,
    output reg change
);reg [7:0] money_inserted = 0;
reg [1:0] candy_dispensed = 0;
reg change_dispensed = 0;

always @(posedge clk) begin
    if (rst) begin
        money_inserted <= 0;
        candy_dispensed <= 0;
        change_dispensed <= 0;
        skittles_dispense <= 0;
        mms_dispense <= 0;
        reeses_dispense <= 0;
        change <= 0;
    end else begin
        if (quarter) money_inserted <= money_inserted + 25;
        if (dime) money_inserted <= money_inserted + 10;
        if (nickel) money_inserted <= money_inserted + 5;

        if (money_inserted >= 50) begin
            if (candy_dispensed == 0) begin
                skittles_dispense <= 1;
                candy_dispensed <= 1;
                money_inserted <= money_inserted - 50;
            end else if (candy_dispensed == 1) begin
                mms_dispense <= 1;
                candy_dispensed <= 2;
                money_inserted <= money_inserted - 50;
            end else if (candy_dispensed == 2) begin
                reeses_dispense <= 1;
                candy_dispensed <= 3;
                money_inserted <= money_inserted - 50;
            end
        end else if (money_inserted == 0 && candy_dispensed > 0) begin
            change <= 1;
            change_dispensed <= 1;
        end
    end
end

endmodule