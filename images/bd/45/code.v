module register_8bit (
    input clk,
    input reset,
    input enable,
    input [7:0] data,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 8'b00000000;
        end else if (enable) begin
            q <= data;
        end
    end

endmodule