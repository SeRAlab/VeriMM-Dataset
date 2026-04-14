module top_module(
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);reg [31:0] counter;

always @(posedge clk, posedge reset) begin
    if (reset) begin
        counter <= 0;
        out <= 0;
    end
    else begin
        counter <= counter + 1;
        if (in < counter) begin
            out <= 1;
        end
    end
end

endmodule