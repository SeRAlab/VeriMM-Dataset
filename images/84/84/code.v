module sync_reset_register (
    input clk,
    input enable,
    input reset,
    input [3:0] D,
    output reg [3:0] Q
);

    always @(posedge clk) begin
        if (reset)
            Q <= 4'b0000;
        else if (enable)
            Q <= D;
    end

endmodule