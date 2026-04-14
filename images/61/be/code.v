module register_8bit(
    input clk,
    input enable,
    input [7:0] data_in,
    output reg [7:0] q
);
    always @(posedge clk) begin
        if (enable)
            q <= data_in;
    end
endmodule