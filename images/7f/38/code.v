module top_module(
    input clk, reset, coin, button,
    input [1:0] drink_code,
    output reg [1:0] dispensed_drink,
    output reg [1:0] change
);reg [1:0] selected_drink;
reg [2:0] balance = 4'b0100;

always @(posedge clk) begin
    if(reset) begin
        balance <= 4'b0100;
        selected_drink <= 2'b00;
        dispensed_drink <= 2'b00;
        change <= 2'b00;
    end else begin
        if(button) begin
            if(coin) begin
                if(balance >= 2'b10) begin
                    balance <= balance - 2'b10;
                    selected_drink <= drink_code;
                    dispensed_drink <= drink_code;
                    change <= balance;
                    balance <= 2'b00;
                end else begin
                    dispensed_drink <= 2'b00;
                    change <= balance;
                    balance <= 2'b00;
                end
            end else begin
                dispensed_drink <= 2'b00;
                change <= balance;
                balance <= 2'b00;
            end
        end else begin
            dispensed_drink <= 2'b00;
            change <= balance;
            balance <= 2'b00;
        end
    end
end

endmodule