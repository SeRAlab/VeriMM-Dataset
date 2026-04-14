module top_module(
    input clk,
    input reset,
    input [15:0] in,
    output reg out
);reg [15:0] prev_in;
reg [15:0] curr_in;

wire transition;
wire is_multiple_of_5;

assign transition = (prev_in ^ curr_in) & curr_in[0];
assign is_multiple_of_5 = (in % 5 == 0);

always @(posedge clk) begin
    if (reset) begin
        prev_in <= 16'b0;
        curr_in <= 16'b0;
        out <= 1'b0;
    end else begin
        prev_in <= curr_in;
        curr_in <= in;
        if (transition) begin
            if (is_multiple_of_5) begin
                out <= 1'b0;
            end else begin
                out <= 1'b1;
            end
        end
    end
end

endmodule