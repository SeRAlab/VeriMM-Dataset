module top_module(
    input a,
    input b,
    input clk,         // Added clk input declaration
    output reg c
);reg [3:0] delay;

always @(posedge clk)  // Changed to trigger on clk
begin
    if (delay == 10)
    begin
        c <= a;
        delay <= 0;    // Reset delay when capturing input
    end
    else
    begin
        delay <= delay + 1;  // Increment delay
    end
end

endmodule