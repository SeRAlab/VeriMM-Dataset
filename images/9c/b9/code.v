module top_module(
    input refclk,
    input rst,
    output reg outclk, // Change to reg
    output locked
);reg locked_reg;
reg [21:0] counter;
reg [1:0] feedback_divider;
reg [4:0] refclk_divider;

parameter REFCLK_DIVIDER = 20;
parameter FEEDBACK_DIVIDER = 2;
parameter LOCK_TIME = 10000000; // 10 ms
parameter CLK_PERIOD = 40; // 25 MHz

always @(posedge refclk or posedge rst) begin
    if (rst) begin
        locked_reg <= 0;
        counter <= 0;
        feedback_divider <= 0;
        refclk_divider <= 0;
        outclk <= 0;
    end else begin
        if (counter == LOCK_TIME) begin
            locked_reg <= 1;
        end
        counter <= counter + 1;
        if (feedback_divider == FEEDBACK_DIVIDER) begin
            feedback_divider <= 0;
            if (refclk_divider == REFCLK_DIVIDER) begin
                refclk_divider <= 0;
                outclk <= ~outclk;
            end else begin
                refclk_divider <= refclk_divider + 1;
            end
        end else begin
            feedback_divider <= feedback_divider + 1;
        end
    end
end

assign locked = locked_reg;

endmodule