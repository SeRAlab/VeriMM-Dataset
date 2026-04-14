module watchdog_timer (
    input clk,
    input reset,
    output reg timeout
);
    reg [2:0] count; // 3-bit counter for 0 to 7 counts

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 3'b000;
            timeout <= 1'b0;
        end else begin
            if (count >= 3'b101) begin // After 5 counts
                timeout <= 1'b1;
            end else begin
                count <= count + 1;
                timeout <= 1'b0;
            end
        end
    end
endmodule