module ring_counter (
    input clk,
    input reset,
    input enable,
    output reg [4:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 5'b00001; // Initial state
        end else if (enable) begin
            count <= {count[3:0], count[4]}; // Shift left with wrap-around
        end
    end
endmodule