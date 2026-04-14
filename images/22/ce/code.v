module interrupt_controller (
    input wire clk,
    input wire enable,
    input wire request,
    output reg interrupt
);
    always @(posedge clk) begin
        if (enable && request) begin
            interrupt <= 1'b1;
        end
        else if (!enable) begin
            interrupt <= 1'b0;
        end
    end
endmodule