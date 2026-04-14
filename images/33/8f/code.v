module ring_counter (
    input clk,
    input reset,
    output reg [3:0] counter
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 4'b0001; // Reset to 0001
        end else begin
            counter <= {counter[2:0], counter[3]}; // Shift left
        end
    end
endmodule