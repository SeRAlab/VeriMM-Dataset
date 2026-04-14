module top_module(
    input [1:0] product_sel,
    input [3:0] money_in,
    output reg dispense,
    output reg [3:0] change
);// Define the prices of the products
    parameter PRICE_1 = 4'd2; // 50 cents (assuming 50 cents is represented as 2 in 4-bit)
    parameter PRICE_2 = 4'd3; // 75 cents (assuming 75 cents is represented as 3 in 4-bit)
    parameter PRICE_3 = 4'd4; // 1 dollar (assuming 1 dollar is represented as 4 in 4-bit)
    parameter PRICE_4 = 4'd5; // 1 dollar 25 cents (assuming 1 dollar 25 cents is represented as 5 in 4-bit)
    
    // Define the total cost of the selected product
    reg [3:0] total_cost;
    always @(*) begin
        case (product_sel)
            2'b00: total_cost = PRICE_1;
            2'b01: total_cost = PRICE_2;
            2'b10: total_cost = PRICE_3;
            2'b11: total_cost = PRICE_4;
            default: total_cost = 4'd0; // default case to avoid latches
        endcase
    end
    
    // Define the remaining amount of money needed to dispense the product
    reg [3:0] remaining_cost;
    always @(*) begin
        if (total_cost > money_in)
            remaining_cost = total_cost - money_in;
        else
            remaining_cost = 0;
    end
    
    // Define the amount of change to be returned to the user
    reg [3:0] change_due;
    always @(*) begin
        if (remaining_cost == 0)
            change_due = money_in - total_cost;
        else
            change_due = 0;
    end
    
    // Define the dispense signal
    always @(*) begin
        if (remaining_cost == 0)
            dispense = 1;
        else
            dispense = 0;
    end
    
    // Define the change signal
    always @(*) begin
        if (remaining_cost == 0)
            change = change_due;
        else
            change = 0;
    end

endmodule