module top_module(
    input wire clk,
    input wire reset,
    input wire in,
    output reg [7:0] count_out
);reg in_prev;

always @(posedge clk, posedge reset) begin
    if (reset) begin
        count_out <= 0;
        in_prev <= 0;
    end
    else begin
        if (in && !in_prev) begin
            count_out <= count_out + 1;
        end
        in_prev <= in;
    end
end

endmodule