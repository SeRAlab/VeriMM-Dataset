module ring_counter(
    input clk,
    input reset,
    output reg [4:0] counter_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter_out <= 5'b00001; // Initialize the counter
        end else begin
            counter_out <= {counter_out[3:0], counter_out[4]}; // Shift the '1'
        end
    end
endmodule