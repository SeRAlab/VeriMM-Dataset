module sync_counter(
    input clk,
    input reset,
    input enable,
    input load,
    input [3:0] data,
    output reg [3:0] q
    );

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0000;
        end else if (load) begin
            q <= data;
        end else if (enable) begin
            q <= q + 1;
        end
    end
endmodule