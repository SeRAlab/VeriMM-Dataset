module top_module(
    areset,
    inclk0,
    c0,
    c1,
    locked
);input areset;
input inclk0;
output reg c0;
output reg c1;
output reg locked;

// Internal signals
reg [31:0] counter0 = 0;
reg [31:0] counter1 = 0;
reg locked_internal = 0;

// Divide the input clock to get the desired frequencies
parameter C0_DIVIDER = 5;
parameter C1_DIVIDER = 10;

// Counters to generate the output clocks
always @(posedge inclk0 or posedge areset) begin
    if (areset) begin
        counter0 <= 0;
        counter1 <= 0;
        locked_internal <= 0;
    end else begin
        counter0 <= counter0 + 1;
        counter1 <= counter1 + 1;
        if (counter0 == C0_DIVIDER - 1) begin
            counter0 <= 0;
            c0 <= ~c0;
        end
        if (counter1 == C1_DIVIDER - 1) begin
            counter1 <= 0;
            c1 <= ~c1;
        end
        if (counter0 == 0 && counter1 == 0) begin
            locked_internal <= 1;
        end
    end
end

// Output the locked signal
assign locked = locked_internal;

endmodule