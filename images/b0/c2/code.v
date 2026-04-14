module top_module(
    input clk,
    input rst,
    output reg [7:0] data
);

    always @(posedge clk) begin
        if (rst)
            data <= 8'b00000001;
        else
            data <= {data[6:0], data[7] ^ data[5]};
    end

endmodule