module divide_by_4 (
    input wire clk,
    input wire enable,
    input wire [1:0] in_data,
    output reg [1:0] out_data
);
    always @(posedge clk) begin
        if (enable) begin
            out_data <= in_data >> 2; // Divide by 4 using right shift
        end
    end
endmodule