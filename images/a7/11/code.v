module top_module(
    input clk,
    input reset,            // Synchronous reset
    input [7:0] d,
    input shift_left,       // Control signal to shift left
    input shift_right,      // Control signal to shift right
    output reg [3:0] q
);reg [7:0] storage [0:3]; // 8-bit binary number storage
    reg [7:0] temp;          // Temporary variable for shifting

    always @(posedge clk) begin
        if (reset) begin
            storage[0] <= 0;
            storage[1] <= 0;
            storage[2] <= 0;
            storage[3] <= 0;
            q <= 0;
        end else begin
            // Shift left
            if (shift_left) begin
                temp[7] <= storage[0][0];
                temp[6:0] <= storage[0][7:1];
                storage[0] <= d;
                storage[1] <= temp;
                temp[7] <= storage[2][0];
                temp[6:0] <= storage[2][7:1];
                storage[2] <= storage[1];
                storage[3] <= temp;
            end
            // Shift right
            else if (shift_right) begin
                temp[0] <= storage[3][7];
                temp[7:1] <= storage[3][6:0]; // Fixed part select order
                storage[3] <= d;
                storage[2] <= temp;
                temp[0] <= storage[1][7];
                temp[7:1] <= storage[1][6:0]; // Fixed part select order
                storage[1] <= storage[2];
                storage[0] <= temp;
            end
            // No shift
            else begin
                storage[0] <= d;
                storage[1] <= storage[0];
                storage[2] <= storage[1];
                storage[3] <= storage[2];
            end
            // Bit-wise logical operation
            q <= {storage[3][0] & storage[2][0], storage[1][0] & storage[0][0]};
        end
    end

endmodule