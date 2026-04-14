module clock_divider (
    input wire clk_in,
    output reg clk_out
);
    reg [1:0] counter;

    always @(posedge clk_in) begin
        counter <= counter + 1;
        clk_out <= counter[1]; // Toggle clk_out on every second clock
    end
endmodule