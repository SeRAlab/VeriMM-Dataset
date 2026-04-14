module divide_by_4 (
    input wire clk,
    input wire rst,
    input wire [3:0] in,
    output reg [1:0] out
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= 2'b00;
        end else begin
            out <= in[3:2]; // Divide by 4: take the two most significant bits
        end
    end
endmodule