module watchdog_timer(
    input clk,
    input reset,
    input enable,
    input [3:0] timeout_value,
    output reg timeout_flag
);
    reg [3:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 4'b0000;
            timeout_flag <= 0;
        end else if (enable) begin
            if (counter < timeout_value) begin
                counter <= counter + 1;
                timeout_flag <= 0;
            end else begin
                timeout_flag <= 1; // timeout condition
            end
        end
    end
endmodule