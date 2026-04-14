module call_option_payoff (
    input [15:0] current_price, // Current stock price
    input [15:0] strike_price,   // Strike price
    output [15:0] payoff         // Payoff of the option
);
    assign payoff = (current_price > strike_price) ? (current_price - strike_price) : 16'b0;
endmodule