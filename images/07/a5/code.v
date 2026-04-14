module johnson_counter (
    input wire clk,
    input wire reset,
    output reg [4:0] q
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 5'b00000; // Reset to 0
        end else begin
            q <= {q[3:0], ~q[4]}; // Shift left and invert the last bit
        end
    end
endmodule