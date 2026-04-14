module top_module(
    input clk,
    input d,
    output q
);reg q1, q2;

// First D flip-flop captures data on rising edge of clock
always @(posedge clk) begin
    q1 <= d;
end

// Second D flip-flop captures output of first flip-flop on falling edge of clock
always @(negedge clk) begin
    q2 <= q1;
end

// Output of second flip-flop is the output of the module
assign q = q2;

endmodule