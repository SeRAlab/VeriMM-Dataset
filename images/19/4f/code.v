module ring_counter (
    input wire clk,
    input wire reset,
    output reg [3:0] count
);

    // Initial state of the ring counter
    initial begin
        count = 4'b0001;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'b0001; // Reset to initial state
        end else begin
            count <= {count[2:0], count[3]}; // Shift right and wrap around
        end
    end
endmodule