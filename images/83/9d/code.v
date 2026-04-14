module top_module(
    input clk,
    input reset,
    input signal,
    output reg [31:0] output_reg
);reg signal_d;
always @(posedge clk) begin
    signal_d <= signal;
    if (reset) begin
        output_reg <= 1;
    end else if (signal_d && !signal) begin
        output_reg <= {32{1'b1}};
    end
end

endmodule