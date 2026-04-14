module ring_counter (
    input wire clk,
    input wire reset,
    output reg [4:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 5'b10000; // Initial state
        end else begin
            count <= {count[0], count[4:1]}; // Shift right
        end
    end
endmodule