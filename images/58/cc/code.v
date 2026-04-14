module sync_up_counter_8bit (
    input wire clk,
    input wire reset,
    input wire enable,
    output reg [7:0] q
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 8'b0;
        end else if (enable) begin
            q <= q + 1'b1;
        end
    end

endmodule