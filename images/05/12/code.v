module watchdog_timer (
    input wire clk,
    input wire reset,
    input wire feed,
    output reg timeout
);
    reg [2:0] counter; // 3-bit counter for 0 to 7

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 3'b000;
            timeout <= 1'b0;
        end else if (feed) begin
            counter <= 3'b000;
            timeout <= 1'b0;
        end else if (counter < 3'b101) begin
            counter <= counter + 1;
            timeout <= 1'b0;
        end else begin
            timeout <= 1'b1; // Timeout after 5 cycles
        end
    end
endmodule