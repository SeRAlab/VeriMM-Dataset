module shift_register
(
    input clk,
    input reset,
    input load,
    input [3:0] data_in,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0000; // Clear register to 0000
        end else if (load) begin
            q <= data_in; // Load new data
        end else begin
            q <= {q[2:0], 1'b0}; // Shift left
        end
    end

endmodule