module reset_controller (
    input wire clk,
    input wire reset,
    output reg state
);
    parameter IDLE = 1'b0;
    parameter ACTIVE = 1'b1;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= ACTIVE;
        end
    end
endmodule