module my_clock (
    input clk_in,
    input reset,
    output reg clk_out,
    output reg reset_out
);

reg [3:0] reset_delay; // delay counter for reset signal

always @(posedge clk_in) begin
    // divide clock by 2
    clk_out <= ~clk_out;
    
    // delay reset signal by 5 clock cycles
    if (reset_delay == 4) begin
        reset_out <= reset;
    end else begin
        reset_out <= 1'b0;
        reset_delay <= reset_delay + 1;
    end
end

endmodule