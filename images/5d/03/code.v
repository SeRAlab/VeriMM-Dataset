module johnson_counter
(
    input clk,
    input reset,
    output reg [5:0] count
);
    always @(posedge clk) begin
        if (reset) begin
            count <= 6'b000001; // Set counter to initial value
        end else begin
            count <= {~count[0], count[5:1]}; // Rotate right with inverted bit
        end
    end

endmodule