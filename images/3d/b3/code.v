module divide_by_4 (
    input wire clk,
    input wire reset,
    input wire [7:0] in_value,
    output reg [7:0] out_value
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out_value <= 8'b0;
        end else begin
            out_value <= in_value >> 2; // Divide by 4
        end
    end
endmodule