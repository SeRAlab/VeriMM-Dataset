module data_register(
    input clk,
    input rst,
    input en,
    input [15:0] d,
    
    output reg [15:0] q
);
    always @(posedge clk) begin
        if (rst) begin
            q <= 16'b0000000000000000;
        end else if (en) begin
            q <= d;
        end
    end
endmodule