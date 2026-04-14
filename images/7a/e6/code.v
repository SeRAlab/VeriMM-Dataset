module top_module (
    input clk,
    input load,
    input clear,
    input [7:0] data,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (clear)
            q <= 8'b00000000; // Synchronous clear to zero
        else if (load)
            q <= data; // Load data into the register
    end

endmodule