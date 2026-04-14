module top_module(
    input clk,
    input reset,
    output reg clk_delayed,
    output reg reset_delayed
);reg [1:0] clk_delay;
    reg [1:0] reset_delay;
    
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            clk_delay <= 2'b0;
            reset_delay <= 2'b0;
        end else begin
            clk_delay <= {clk, clk_delay[1]};
            reset_delay <= {reset, reset_delay[1]};
        end
    end
    
    assign clk_delayed = clk_delay[0];
    assign reset_delayed = reset_delay[0];

endmodule