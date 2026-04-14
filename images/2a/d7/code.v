module ring_counter (
    input wire clk,
    input wire reset,
    output reg [4:0] counter
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 5'b00001; // Initialize counter to 00001 on reset
        end else begin
            counter <= {counter[3:0], counter[4]}; // Shift right
        end
    end
endmodule