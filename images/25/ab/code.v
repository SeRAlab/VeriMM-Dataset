module ring_counter (
    input clk,
    input rst,
    output reg [4:0] q
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 5'b00001; // Reset to the initial state
        else
            q <= {q[3:0], q[4]}; // Shift left and wrap around
    end
endmodule