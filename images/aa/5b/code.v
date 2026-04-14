module simple_register (
    input clk,
    input reset,
    input enable,
    input [7:0] data_in,
    output reg [7:0] q
);

    // Register logic
    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 8'b00000000;
        else if (enable)
            q <= data_in;
    end

endmodule