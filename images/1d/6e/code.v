module reset_controller (
    input clk,
    input reset_n,
    output reg reset_out
);

always @(posedge clk) begin
    if (!reset_n) begin
        reset_out <= 1'b1; // Assert reset_out when reset_n is low
    end else begin
        reset_out <= 1'b0; // Deassert reset_out on the next clock edge
    end
end

endmodule