module register (
    input clk,
    input enable,
    input [7:0] data_in,
    output reg [7:0] data_out
);

    // Register logic
    always @(posedge clk) begin
        if (enable)
            data_out <= data_in;
    end

endmodule