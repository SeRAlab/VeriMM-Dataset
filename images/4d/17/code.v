module register_with_enable(
    input clk,
    input rst,
    input en,
    input [4:0] data,
    
    output reg [4:0] q
);
    always @(posedge clk) begin
        if (rst) begin
            q <= 5'b00000;
        end else if (en) begin
            q <= data;
        end
    end
endmodule