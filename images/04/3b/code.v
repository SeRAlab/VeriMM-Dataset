module interrupt_controller (
    input wire clk,
    input wire reset,
    input wire [3:0] interrupt_requests,
    input wire enable,
    output reg interrupt_active
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            interrupt_active <= 0;
        end else if (enable) begin
            interrupt_active <= |interrupt_requests; // Active if any request is asserted
        end
    end
endmodule