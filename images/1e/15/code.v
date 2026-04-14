module timer_16bit (
    input clk,
    input reset,
    output reg [15:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 16'b0;
        end else begin
            count <= count + 1;
        end
    end
endmodule