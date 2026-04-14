module top_module(
    input async_input,
    input clk,
    input reset,
    output reg sync_output
);reg sync_ff;

always @(posedge clk) begin
    sync_ff <= async_input;
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        sync_ff <= 1'b0;
    end else begin
        sync_output <= sync_ff;
    end
end

endmodule