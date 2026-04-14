module watchdog_timer (
    input wire clk,
    input wire reset,
    input wire [3:0] threshold,
    output reg timeout
);
    reg [3:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 4'b0000;
            timeout <= 1'b0;
        end else begin
            if (counter < threshold) begin
                counter <= counter + 1;
                timeout <= 1'b0;
            end else begin
                timeout <= 1'b1; // Timeout condition
            end
        end
    end
endmodule