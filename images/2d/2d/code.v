module watchdog_timer (
    input wire clk,
    input wire reset,
    input wire enable,
    output reg timeout
);
    reg [2:0] count; // 3 bits for counting up to 8

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 3'b000;
            timeout <= 1'b0;
        end else if (enable) begin
            if (count < 3'b111) begin
                count <= count + 1;
                timeout <= 1'b0;
            end else begin
                timeout <= 1'b1; // timeout occurs
            end
        end
    end
endmodule