module register_8bit_async_reset(
    input [7:0] data,
    input clk,
    input rst,
    output reg [7:0] q
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 8'b0;
        else
            q <= data;
    end

endmodule