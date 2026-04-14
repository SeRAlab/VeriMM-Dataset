module clock_delay_inverter(
    input clk,
    input [3:0] delay,
    output reg clk_delayed
);

reg [3:0] counter;

always @(posedge clk) begin
    if (counter == delay) begin
        clk_delayed <= ~clk_delayed;
        counter <= 0;
    end else begin
        counter <= counter + 1;
    end
end

endmodule