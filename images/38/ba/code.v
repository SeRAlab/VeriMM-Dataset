module current_sensor (
    input clk,
    input reset,
    input [7:0] current_value,
    input [7:0] threshold,
    output reg alert
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            alert <= 0;
        end else if (current_value > threshold) begin
            alert <= 1;
        end else begin
            alert <= 0;
        end
    end
endmodule