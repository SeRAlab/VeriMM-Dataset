module top_module (
    input clk,
    input en,
    input [15:0] data,
    output reg [15:0] q
);

    always @(posedge clk) begin
        if (en)
            q <= data; // Load data into the register
    end

endmodule