module top_module(
    inclk0,
    c0,
    c1,
    c2
);input inclk0;
output c0;
output c1;
output c2;

wire clk;

// Generate the base clock signal
assign clk = inclk0;

// Generate c0 with a frequency of 1.35 MHz and a phase shift of 0 degrees
reg [23:0] counter_c0 = 0;
reg c0_internal = 0;
always @(posedge clk) begin
    counter_c0 <= counter_c0 + 1;
    if (counter_c0 == 17777) begin
        c0_internal <= ~c0_internal;
        counter_c0 <= 0;
    end
end
assign c0 = c0_internal;

// Generate c1 with a frequency of 13.5 MHz and no phase shift
reg [3:0] counter_c1 = 0;
reg c1_internal = 0;
always @(posedge clk) begin
    counter_c1 <= counter_c1 + 1;
    if (counter_c1 == 1) begin
        c1_internal <= ~c1_internal;
        counter_c1 <= 0;
    end
end
assign c1 = c1_internal;

// Generate c2 with a frequency of 13.5 MHz and a phase shift of 1852 degrees
reg [3:0] counter_c2 = 0;
reg c2_internal = 0;
always @(posedge clk) begin
    counter_c2 <= counter_c2 + 1;
    if (counter_c2 == 1) begin
        c2_internal <= ~c2_internal;
        counter_c2 <= 0;
    end
end
assign c2 = c2_internal ^ ((counter_c2 >= 9) ? 1'b1 : 1'b0);

endmodule