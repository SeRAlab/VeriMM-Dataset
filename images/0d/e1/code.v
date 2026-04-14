module divide_by_8 (
    input clk,
    input [2:0] in,
    output reg [2:0] out
);
    always @(posedge clk) begin
        if (in < 3'b1000) 
            out <= 3'b000; // Output 0 if input is less than 8
        else 
            out <= in / 3'b1000; // Divide by 8
    end
endmodule