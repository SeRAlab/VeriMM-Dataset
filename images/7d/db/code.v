module top_module(
    input clk, rst_n, bps_start,
    output reg clk_baud
);parameter BAUD_RATE = 9600;

reg [31:0] counter;
reg toggle;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        counter <= 0;
        toggle <= 0;
    end
    else if(bps_start) begin
        counter <= counter + 1;
        if(counter == ($freq / (BAUD_RATE * 2))) begin
            toggle <= ~toggle;
            counter <= 0;
        end
    end
end

assign clk_baud = toggle;

endmodule