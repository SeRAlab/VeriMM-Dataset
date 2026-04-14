module timer (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [31:0] start_value,
    output reg [31:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= start_value;
        end else if (enable) begin
            if (count < 32'b11111111111111111111111111111111) begin
                count <= count + 1;
            end
        end
    end
endmodule