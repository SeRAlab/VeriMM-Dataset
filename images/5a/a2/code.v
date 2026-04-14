module top_module(
    input clk,
    input reset,
    input load,
    input up_down,
    input [3:0] data_in,
    output reg [3:0] data_out
);always @(posedge clk or negedge reset) begin
        if (!reset) begin
            data_out <= 4'b0;
        end else if (load) begin
            data_out <= data_in;
        end else if (up_down) begin
            data_out <= data_out + 1;
        end else begin
            data_out <= data_out - 1;
        end
    end

endmodule