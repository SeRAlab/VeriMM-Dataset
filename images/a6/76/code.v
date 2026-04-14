module top_module(
    input clk,
    input rst,
    output reg [15:0] data
);

    always @(posedge clk) begin
        if (rst)
            data <= 16'b0000000000000000;
        else
            data <= {data[14:0], data[15]};
    end

endmodule