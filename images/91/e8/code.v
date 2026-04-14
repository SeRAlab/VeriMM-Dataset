module top_module(
    input clk,
    input reset_n,
    input preset,
    input [11:0] preset_val,
    output reg [11:0] q
);

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            // Asynchronous reset: Reset the counter to 12'b000000000000
            q <= 12'b000000000000;
        end else if (preset) begin
            // Preset operation: Preset the counter with the provided value
            q <= preset_val;
        end else begin
            // Binary counter: Increment by 1
            q <= q + 1;
        end
    end

endmodule