module watchdog_timer(
    input clk,
    input rst,
    input enable,
    output reg timeout
);
    reg [3:0] counter; // 4-bit counter for counting up to 10

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            timeout <= 0;
        end else if (enable) begin
            if (counter < 10) begin
                counter <= counter + 1;
                timeout <= 0;
            end else begin
                timeout <= 1;
            end
        end
    end
endmodule