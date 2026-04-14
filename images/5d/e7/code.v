module ring_counter
(
    input clk,
    input reset,
    output reg [2:0] count
);
    always @(posedge clk) begin
        if (reset) begin
            count <= 3'b001; // Set counter to initial value
        end else begin
            count <= {count[1:0], count[2]}; // Rotate left
        end
    end

endmodule