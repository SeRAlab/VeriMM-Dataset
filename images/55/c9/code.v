module top_module(
    input clk,
    input reset,
    input [1:0] coin,
    input [1:0] item,
    output reg dispense,
    output reg [1:0] change,
    output reg item1,
    output reg item2,
    output reg item3
);reg [3:0] total;
reg [1:0] cost;
reg [1:0] stock;

parameter ITEM1_COST = 2'b01;
parameter ITEM2_COST = 2'b10;
parameter ITEM3_COST = 2'b11;

parameter ITEM1_STOCK = 1;
parameter ITEM2_STOCK = 3;
parameter ITEM3_STOCK = 0;

always @(posedge clk) begin
    if (reset) begin
        total <= 0;
        cost <= 0;
        stock <= {ITEM1_STOCK, ITEM2_STOCK, ITEM3_STOCK};
        dispense <= 0;
        change <= 0;
        item1 <= ITEM1_STOCK;
        item2 <= ITEM2_STOCK;
        item3 <= ITEM3_STOCK;
    end else begin
        case (coin)
            2'b00: total <= total;
            2'b01: total <= total + 5;
            2'b10: total <= total + 10;
            2'b11: total <= total + 25;
        endcase
        case (item)
            2'b00: cost <= 0;
            2'b01: cost <= ITEM1_COST;
            2'b10: cost <= ITEM2_COST;
            2'b11: cost <= ITEM3_COST;
        endcase
        if (item == 2'b01 && cost <= total && stock[0]) begin
            dispense <= 1;
            change <= total - ITEM1_COST;
            total <= 0;
            stock[0] <= stock[0] - 1;
        end else if (item == 2'b10 && cost <= total && stock[1]) begin
            dispense <= 1;
            change <= total - ITEM2_COST;
            total <= 0;
            stock[1] <= stock[1] - 1;
        end else if (item == 2'b11 && cost <= total && stock[2]) begin
            dispense <= 1;
            change <= total - ITEM3_COST;
            total <= 0;
            stock[2] <= stock[2] - 1;
        end else begin
            dispense <= 0;
            change <= total;
            total <= 0;
        end
        item1 <= stock[0];
        item2 <= stock[1];
        item3 <= stock[2];
    end
end

endmodule