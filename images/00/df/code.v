module reset_controller (
    input wire clk,
    input wire reset_n,
    output reg reset_out
);

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        reset_out <= 1'b1;  // Set output to 1 (reset state)
    end else begin
        reset_out <= 1'b0;  // Release reset
    end
end

endmodule