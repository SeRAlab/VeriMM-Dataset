module top_module(
    input clk,
    input reset,
    input [1:0] coin,
    input [1:0] dispense,
    output reg dispenser1,
    output reg dispenser2,
    output reg dispenser3,
    output reg dispenser4,
    output reg [1:0] change
);parameter product_price = 2'b10; // 50 cents
parameter coin_value = {2'b00, 2'b01, 2'b10, 2'b11}; // 5 cents, 10 cents, 25 cents, 1 dollar

reg [1:0] amount_inserted; // total amount of money inserted so far

always @(posedge clk) begin
    if (reset) begin
        amount_inserted <= 0;
        dispenser1 <= 0;
        dispenser2 <= 0;
        dispenser3 <= 0;
        dispenser4 <= 0;
        change <= 2'b00;
    end else begin
        amount_inserted <= amount_inserted + coin_value[coin];
        if (amount_inserted >= product_price) begin
            case (dispense)
                2'b00: dispenser1 <= 1;
                2'b01: dispenser2 <= 1;
                2'b10: dispenser3 <= 1;
                2'b11: dispenser4 <= 1;
            endcase
            change <= amount_inserted - product_price;
            amount_inserted <= 0;
        end else if (amount_inserted > 0) begin
            change <= amount_inserted;
            amount_inserted <= 0;
        end
    end
end

endmodule