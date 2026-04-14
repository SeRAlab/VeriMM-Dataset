module timer_16bit (
    input clk,
    input reset,
    input start_stop,
    output reg [15:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 16'b0;
        end else if (start_stop) begin
            if (count < 16'hFFFF) begin
                count <= count + 1;
            end else begin
                count <= 16'b0;
            end
        end
    end
endmodule