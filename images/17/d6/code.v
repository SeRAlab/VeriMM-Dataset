module interrupt_controller (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire request,
    input wire acknowledge,
    output reg interrupt
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            interrupt <= 0;
        end else if (enable && request) begin
            interrupt <= 1;
        end else if (acknowledge) begin
            interrupt <= 0;
        end
    end

endmodule