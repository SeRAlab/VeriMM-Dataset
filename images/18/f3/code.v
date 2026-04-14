module shift_register (
    input clk,                // Clock signal
    input reset,              // Reset signal
    input [3:0] data_in,      // Data input
    input shift_left,         // Control signal for left shift
    input shift_right,        // Control signal for right shift
    output reg [3:0] q        // 4-bit output
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 4'b0000;      // Reset the register to 0
        end else if (shift_left && !shift_right) begin
            q <= {q[2:0], data_in[0]};  // Shift left and insert data_in[0]
        end else if (shift_right && !shift_left) begin
            q <= {data_in[3], q[3:1]};   // Shift right and insert data_in[3]
        end
    end
endmodule