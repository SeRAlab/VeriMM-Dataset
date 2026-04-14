module shift_register (
    input clk,
    input load,
    input shift,
    input [7:0] data,
    output reg [7:0] q
);
    always @(posedge clk) begin
        if (load) begin
            q <= data;  // Load the data
        end else if (shift) begin
            q <= {1'b0, q[7:1]};  // Shift right with zero fill
        end
        // If neither load nor shift, retain the current state
    end
endmodule