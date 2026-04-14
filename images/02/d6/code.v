module watchdog_timer (
    input wire clk,
    input wire rst,
    input wire enable,
    output reg timeout
);
    reg [3:0] count; // 4-bit counter to count up to 10

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 4'b0000;
            timeout <= 0;
        end else if (enable) begin
            if (count < 4'b1001) begin // Count until 10 (0-9)
                count <= count + 1;
                timeout <= 0;
            end else begin
                timeout <= 1; // Assert timeout after reaching 10
            end
        end
    end
endmodule