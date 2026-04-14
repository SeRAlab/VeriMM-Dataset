module state_space_controller(
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [2:0] control,
    output reg [2:0] state
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 3'b000;
        end else if (enable) begin
            state <= control;
        end
    end
endmodule