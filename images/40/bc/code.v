module reset_controller(
    input wire clk,
    input wire rst_n, // Active low reset
    input wire sync_rst, // Synchronous reset
    output reg out
);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out <= 0; // Asynchronous reset
        end else if (sync_rst) begin
            out <= 0; // Synchronous reset
        end
    end

endmodule