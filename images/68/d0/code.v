module top_module(
    input A,
    input clk,           // Added clk input needed for the always block
    output X
);parameter DELAY_TIME = 10; // Delay time in nanoseconds

reg [DELAY_TIME-1:0] delay_reg; // Register to hold delayed signal

always @(posedge clk) begin
    delay_reg <= {delay_reg[(DELAY_TIME-2):0], A};
end

assign X = delay_reg[DELAY_TIME-1];

endmodule