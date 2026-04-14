module watchdog_timer (
    input wire clk,
    input wire reset,
    input wire start,
    output reg timeout
);
    reg [1:0] count; // 2-bit counter

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            timeout <= 0;
        end else if (start) begin
            if (count < 3) begin
                count <= count + 1;
                timeout <= 0;
            end else begin
                timeout <= 1; // timeout after 4 clock cycles
            end
        end
    end
endmodule