module timer (
    input clk,
    input reset,
    input [31:0] max_value,
    output reg [31:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 32'b0;
        end else if (count < max_value) begin
            count <= count + 1;
        end else begin
            count <= 32'b0; // Reset to zero when max_value is reached
        end
    end
endmodule