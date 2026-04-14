module watchdog_timer #(parameter MAX_COUNT = 10) (
    input wire clk,
    input wire reset,
    output reg timeout
);
    reg [3:0] count; // 4-bit counter

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            timeout <= 0;
        end else begin
            if (count < MAX_COUNT) begin
                count <= count + 1;
                timeout <= 0;
            end else begin
                timeout <= 1; // Timeout condition
            end
        end
    end
endmodule