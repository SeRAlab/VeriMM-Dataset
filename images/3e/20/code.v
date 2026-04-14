module watchdog_timer (
    input clk,
    input rst,
    input enable,
    input [3:0] timeout, // 4-bit timeout value
    output reg timeout_expired
);
    reg [3:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 4'b0000;
            timeout_expired <= 1'b0;
        end else if (enable) begin
            if (count < timeout) begin
                count <= count + 1;
                timeout_expired <= 1'b0;
            end else begin
                timeout_expired <= 1'b1; // Timeout has expired
            end
        end else begin
            count <= 4'b0000; // Reset count if not enabled
            timeout_expired <= 1'b0;
        end
    end
endmodule