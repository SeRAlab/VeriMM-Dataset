module timer(
    input clk,
    input reset,
    input enable,
    input [7:0] max_value,
    output reg [7:0] current_value
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_value <= 8'b0;
        end else if (enable) begin
            if (current_value < max_value) begin
                current_value <= current_value + 1;
            end else begin
                current_value <= 8'b0; // Reset to zero when max_value is reached
            end
        end
    end
endmodule