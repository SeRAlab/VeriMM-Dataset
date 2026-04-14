module top_module(
    input clk,
    output reg clk_delayed
);parameter delay = 1;

reg [31:0] counter = 0;

always @(posedge clk) begin
    counter <= counter + 1;
    if (counter == delay * 10) begin
        clk_delayed <= 1;
        counter <= 0;
    end else begin
        clk_delayed <= 0;
    end
end

endmodule