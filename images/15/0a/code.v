module current_sensor (
    input wire clk,
    input wire reset,
    input wire [9:0] current,
    input wire [9:0] threshold,
    output reg alert
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            alert <= 0;
        end else begin
            if (current > threshold) begin
                alert <= 1;
            end else begin
                alert <= 0;
            end
        end
    end
endmodule