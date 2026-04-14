module reset_controller (
    input clk,
    input rst_n,
    output reg reset_state
);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reset_state <= 1'b1; // Reset state
        end else begin
            reset_state <= 1'b0; // Active state
        end
    end

endmodule