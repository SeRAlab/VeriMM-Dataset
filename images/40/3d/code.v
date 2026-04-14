module watchdog_timer(
    input clk,
    input reset,
    output reg timeout
);
    reg [2:0] count; // 3-bit count to represent values 0-7

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 3'b000;
            timeout <= 1'b0;
        end else begin
            if (count < 3'b111) begin
                count <= count + 1'b1;
            end
            if (count == 3'b111) begin
                timeout <= 1'b1;
            end
        end
    end
endmodule