module top_module(
    input clk, // Clock input
    input reset, // Asynchronous reset input
    output reg out_clk // Output clock signal with half the frequency of the input clock
);reg Q1, Q2;

always @(posedge clk, negedge reset) begin
    if (!reset) begin
        Q1 <= 0;
        Q2 <= 0;
    end else begin
        Q1 <= ~Q1;
        Q2 <= ~Q2;
    end
end

assign out_clk = Q1 & Q2;

endmodule