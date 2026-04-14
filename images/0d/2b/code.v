module reset_controller (
    input wire clk,
    input wire rst,
    output reg status
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        status <= 1'b0; // Reset state
    end else begin
        status <= 1'b1; // Operational state
    end
end

endmodule