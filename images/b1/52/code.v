module top_module(
    input clk_50mhz,
    output reg clk_1khz
);reg [26:0] count; // Adjusted size to count enough clock cycles

always @(posedge clk_50mhz) begin
    count <= count + 1;
    if(count >= 25000) begin // 50MHz / 2khz = 25000
        count <= 0;
        clk_1khz <= ~clk_1khz;
    end
end

endmodule