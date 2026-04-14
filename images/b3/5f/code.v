module parallel_load_register(
    input clk,
    input rst,
    input ld,
    input [15:0] data,
    
    output reg [15:0] q
);
    always @(posedge clk) begin
        if (rst) begin
            q <= 16'b0000000000000000;
        end else if (ld) begin
            q <= data;
        end
    end
endmodule