module reset_controller (
    input wire clk,
    input wire reset,
    output reg reset_active,
    output reg system_ready
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reset_active <= 1'b1;
            system_ready <= 1'b0;
        end else begin
            reset_active <= 1'b0;
            system_ready <= 1'b1;
        end
    end
endmodule