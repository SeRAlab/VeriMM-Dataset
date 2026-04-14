module top_module(
    input [1:0] button,
    input [7:0] money,
    input [7:0] price,
    output [1:0] product,
    output [7:0] change,
    output [7:0] total_money,
    output [1:0] num_dispensed
    );reg [7:0] total_money_reg = 0;
    reg [1:0] num_dispensed_reg = 0;
    reg [7:0] change_reg = 0;
    reg [1:0] product_reg = 0;

    always @(*) begin
        if (button == 2'b00 && money >= price) begin
            total_money_reg = total_money_reg + money;
            num_dispensed_reg = num_dispensed_reg + 1;
            change_reg = money - price;
            product_reg = 2'b00;
        end else if (button == 2'b01 && money >= price) begin
            total_money_reg = total_money_reg + money;
            num_dispensed_reg = num_dispensed_reg + 1;
            change_reg = money - price;
            product_reg = 2'b01;
        end else if (button == 2'b10 && money >= price) begin
            total_money_reg = total_money_reg + money;
            num_dispensed_reg = num_dispensed_reg + 1;
            change_reg = money - price;
            product_reg = 2'b10;
        end else if (button == 2'b11 && money >= price) begin
            total_money_reg = total_money_reg + money;
            num_dispensed_reg = num_dispensed_reg + 1;
            change_reg = money - price;
            product_reg = 2'b11;
        end else begin
            change_reg = money;
            product_reg = 2'b00;
        end
    end

    assign total_money = total_money_reg;
    assign num_dispensed = num_dispensed_reg;
    assign change = change_reg;
    assign product = product_reg;

endmodule